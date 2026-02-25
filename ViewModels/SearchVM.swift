import Foundation
import SwiftUI
import UIKit

// MARK: - Camera States
enum CameraState {
    case scanning              // AR view, detecting objects, showing 3D hanzi
    case showingCard          // 2D card appeared after capture
    case tracing              // User is tracing the hanzi
    case traced               // Tracing complete, showing full info
}

@MainActor
class SearchVM: ObservableObject {
    @Published var allVocabulary: [Vocabulary]
    @Published var murals: [Mural]
    
    // MARK: - Camera State Management
    @Published var cameraState: CameraState = .scanning
    @Published var detectedWord: Vocabulary? = nil
    @Published var capturedImage: UIImage? = nil
    @Published var showingGallery = false
    
    // Animation states
    @Published var cardAnimatingToGallery = false
    @Published var cardOffset: CGSize = .zero
    
    init() {
        // For playground projects, we'll use sample data directly
        // In a full app, you could load from JSON
        self.allVocabulary = Vocabulary.samples
        self.murals = Mural.samples
        
        print("✅ Loaded \(allVocabulary.count) vocabulary words from samples")
    }
        
    func search(query: String) -> [Vocabulary] {
        guard !query.isEmpty else { return allVocabulary }
        
        let lowercased = query.lowercased()
        return allVocabulary.filter { word in
            word.hanzi.contains(lowercased) ||
            word.pinyin.lowercased().contains(lowercased) ||
            word.english.lowercased().contains(lowercased) ||
            word.object.lowercased().contains(lowercased)
        }
    }
    
    // MARK: - AR Detection
    
    /// Find vocabulary word matching the detected object label
    func findWord(for objectLabel: String) -> Vocabulary? {
        let normalized = normalizeObjectLabel(objectLabel)
        return allVocabulary.first { $0.object.lowercased() == normalized }
    }
    
    /// Normalize object labels from ML model
    private func normalizeObjectLabel(_ label: String) -> String {
        let lowercased = label.lowercased()
        
        // Handle common ML model variations
        let mappings: [String: String] = [
            "laptop computer": "laptop",
            "computer keyboard": "keyboard",
            "cellular telephone": "phone",
            "mobile phone": "phone",
            "dining table": "dining table",
            "potted plant": "potted plant",
            "wine bottle": "bottle",
            "traffic light": "traffic light",
            "fire hydrant": "fire hydrant",
            "stop sign": "stop sign",
            "parking meter": "parking meter",
            "tennis racket": "tennis racket",
            "wine glass": "wine glass",
            "teddy bear": "teddy bear",
            "hair drier": "hair dryer"
        ]
        
        return mappings[lowercased] ?? lowercased
    }
    
    // MARK: - Collection Management
    
    /// Mark a word as collected after user traces it
    func collectWord(id: UUID) {
        if let index = allVocabulary.firstIndex(where: { $0.id == id }) {
            allVocabulary[index].isCollected = true
            print("✅ Collected: \(allVocabulary[index].hanzi)")
            // TODO: Save to UserDefaults for persistence
        }
    }
    
    func collectedWords() -> [Vocabulary] {
        return allVocabulary.filter { $0.isCollected }
    }
    
    func unCollectedWords() -> [Vocabulary] {
        return allVocabulary.filter { !$0.isCollected }
    }
    
    var totalProgress: (collected: Int, total: Int) {
        let collected = collectedWords().count
        let total = allVocabulary.count
        return (collected, total)
    }
    
    /// Progress percentage (0.0 to 1.0)
    var progressPercentage: Double {
        let progress = totalProgress
        guard progress.total > 0 else { return 0.0 }
        return Double(progress.collected) / Double(progress.total)
    }
    
    /// Whether the capture button should be enabled
    var canCapture: Bool {
        cameraState == .scanning && detectedWord != nil
    }
    
    /// Whether to show the floating 3D Hanzi overlay
    var shouldShow3DHanzi: Bool {
        cameraState == .scanning && detectedWord != nil
    }
    
    /// Whether to show the 2D word card overlay
    var shouldShowWordCard: Bool {
        cameraState != .scanning && !cardAnimatingToGallery
    }
    
    /// Whether to show tracing instructions
    var shouldShowTracingInstructions: Bool {
        cameraState == .showingCard || cameraState == .tracing
    }
    
    /// Whether to show completion info (pinyin, english, etc.)
    var shouldShowCompletionInfo: Bool {
        cameraState == .traced
    }
    
    /// Whether to show the tracing simulation button
    var shouldShowTracingButton: Bool {
        cameraState == .showingCard || cameraState == .tracing
    }
    
    // MARK: - Camera Actions
    
    func simulateDetection() {
        // Simulate detecting a "cup" after a delay
        Task {
            try await Task.sleep(for: .seconds(1.0))
            detectedWord = findWord(for: "cup")
        }
    }
    
    func captureObject() {
        guard detectedWord != nil else { return }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            cameraState = .showingCard
        }
        
        // Simulate captured image (in real app, this would be AR snapshot)
        capturedImage = nil
    }
    
    func completeTracing() {
        guard let word = detectedWord else { return }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            cameraState = .traced
        }
        
        // Collect the word
        collectWord(id: word.id)
    }
    
    func animateCardToGallery() {
        // Calculate position to animate to (bottom-left thumbnail)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let targetX = -screenWidth / 2 + 45
        let targetY = screenHeight / 2 - 100
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            cardAnimatingToGallery = true
            cardOffset = CGSize(width: targetX, height: targetY)
        }
        
        // Reset state after animation
        Task {
            try await Task.sleep(for: .seconds(0.6))
            resetCameraState()
        }
    }
    
    func resetCameraState() {
        cameraState = .scanning
        detectedWord = nil
        cardAnimatingToGallery = false
        cardOffset = .zero
        
        // Simulate next detection
        simulateDetection()
    }
}

struct VocabularyData: Codable {
    let vocabulary: [Vocabulary]
    
}

class VocabularyLoader {

    /// Load vocabulary from the JSON file in the bundle
    static func loadFromJSON() -> [Vocabulary] {
        guard let url = Bundle.main.url(forResource: "vocabulary", withExtension: "json") else {
            print("❌ Could not find vocabulary.json in bundle")
            return Vocabulary.samples
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let vocabularyData = try decoder.decode(VocabularyData.self, from: data)
            print("✅ Loaded \(vocabularyData.vocabulary.count) words from JSON")
            return vocabularyData.vocabulary
        } catch {
            print("❌ Error loading vocabulary.json: \(error)")
            print("Using sample data instead")
            return Vocabulary.samples
        }
    }
}
