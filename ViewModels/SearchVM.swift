import Foundation
import SwiftUI
import UIKit

enum CameraState {
    case scanning       // User selecting object
    case showingCard    // Card appeared after capture
    case tracing        // User tracing hanzi
    case traced         // Tracing complete
}

@MainActor
class SearchVM: ObservableObject {
    @Published var allVocabulary: [Vocabulary]
    @Published var cameraState: CameraState = .scanning
    @Published var detectedWord: Vocabulary? = nil
    @Published var showingGallery = false
    @Published var cameraSearchText = ""
    @Published var showingCameraSearchResults = false
    @Published var shouldCapturePhoto = false
    @Published var capturedImage: UIImage? = nil
    @Published var collectedWordsWithImages: [CollectedWord] = []

//    @Published var capturedImage: UIImage? = nil {
//        didSet {
//            if let image = capturedImage {
//                print("📸 capturedImage set! Size: \(image.size)")
//                handleImageCaptured()
//            } else {
//                print("📸 capturedImage cleared")
//            }
//        }
//    }
    
    // animation- might del
    @Published var cardAnimatingToGallery = false
    @Published var cardOffset: CGSize = .zero //?? useless
    
    
    init() {
        self.allVocabulary = VocabularyLoader.loadFromJSON()
    }
        
    func search(query: String) -> [Vocabulary] {
        guard !query.isEmpty else { return [] }
        
        let lowercased = query.lowercased()
        return allVocabulary.filter { word in
            word.hanzi.contains(lowercased) ||
            word.pinyin.lowercased().contains(lowercased) ||
            word.english.lowercased().contains(lowercased) ||
            word.object.lowercased().contains(lowercased)
        }
    }
    
    var cameraSearchResults: [Vocabulary] {
        search(query: cameraSearchText)
    }
    
    func updateCameraSearch(_ text: String) {
        cameraSearchText = text
        showingCameraSearchResults = !text.isEmpty
    }
    
    func clearCameraSearch() {
        cameraSearchText = ""
        showingCameraSearchResults = false
    }
        
    // Select object manually
    func selectObject(_ objectName: String) {
        if let word = findWord(for: objectName) {
            detectedWord = word
            clearCameraSearch() // Auto-close search after selection
            print("✅ Selected: \(objectName) → \(word.hanzi)")
        } else {
            print("⚠️ No vocabulary found for: \(objectName)")
        }
    }
    
    // select word from search
    func selectWord(_ word: Vocabulary) {
        detectedWord = word
        clearCameraSearch() // Auto-close search after selection
        print("✅ Selected word: \(word.object) → \(word.hanzi)")
    }
    
    // Find  by object name
    func findWord(for objectLabel: String) -> Vocabulary? {
        return allVocabulary.first { $0.object.lowercased() == objectLabel.lowercased() }
    }
    
    func clearSelection() {
        detectedWord = nil
        clearCameraSearch()
    }
        
    func collectWord(object: String) {
        if let index = allVocabulary.firstIndex(where: { $0.object == object }) {
            allVocabulary[index].isCollected = true
            print("✅ Collected: \(allVocabulary[index].hanzi)")
            // TODO: Save to UserDefaults
        }
    }
    
    func collectedWords() -> [Vocabulary] {
        return allVocabulary.filter { $0.isCollected }
    }
    
    func unCollectedWords() -> [Vocabulary] {
        return allVocabulary.filter { !$0.isCollected }
    }
    
    var totalProgress: (collected: Int, total: Int) { //is this needed?
        let collected = collectedWords().count
        let total = allVocabulary.count
        return (collected, total)
    }
    
    var progressPercentage: Double {
        let progress = totalProgress
        guard progress.total > 0 else { return 0.0 }
        return Double(progress.collected) / Double(progress.total)
    }
        
    var canCapture: Bool {
        cameraState == .scanning && detectedWord != nil
    }
    
    var canShow3DHanzi: Bool {
        cameraState == .scanning && detectedWord != nil && !showingCameraSearchResults
    }
    
    var canShowWordCard: Bool {
        cameraState != .scanning && !cardAnimatingToGallery
    }
    
    var canShowTracingInstructions: Bool {
        cameraState == .showingCard || cameraState == .tracing
    }
    
    var canShowCompletionInfo: Bool {
        cameraState == .traced
    }
    
    var canShowTracingButton: Bool {
        cameraState == .showingCard || cameraState == .tracing
    }
        
    var canShowSelectionScroll: Bool {
        cameraState == .scanning && !showingCameraSearchResults
    }
    
    func captureObject() {
        guard detectedWord != nil else { return }
        print("1️⃣ Capture button pressed")
        shouldCapturePhoto = true
            
            #if targetEnvironment(simulator)
            // Simulator: skip real photo capture, use placeholder
            let placeholder = UIImage(systemName: "photo") ?? UIImage()
            handlePhotoCaptured(placeholder)
            #endif
    
        withAnimation {
            cameraState = .showingCard
        }
    }
    
    func handlePhotoCaptured(_ image: UIImage) {
        capturedImage = image
        shouldCapturePhoto = false
        print("2️⃣ handlePhotoCaptured called, size: \(image.size)")

        // why are we doing this in both the captureObject and handlePhotoCaptured?
        withAnimation {
            cameraState = .showingCard
        }
    }
  
    func completeTracing() {
        guard let word = detectedWord, let image = capturedImage else { return }
        
        withAnimation {
            cameraState = .traced
        }
        
        let collected = CollectedWord(
            vocabulary: word,
            capturedImage: image,
            capturedDate: Date()
        )
        collectedWordsWithImages.append(collected)
        
        // Mark as collected
        collectWord(object: word.object)
    }
    
    func animateCardToGallery() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let targetX = -screenWidth / 2 + 45
        let targetY = screenHeight / 2 - 100
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            cardAnimatingToGallery = true
            cardOffset = CGSize(width: targetX, height: targetY)
        }
        
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
        capturedImage = nil
        shouldCapturePhoto = false
    }
}

// MARK: - Vocabulary Loader

struct VocabularyData: Codable {
    let vocabulary: [Vocabulary]
}

class VocabularyLoader {
    static func loadFromJSON() -> [Vocabulary] {
            guard let data = Vocabulary.vocabularyJSON.data(using: .utf8) else {
                print("❌ Could not convert JSON string to data")
                return []
            }
            
            do {
                let decoder = JSONDecoder()
                let vocabularyData = try decoder.decode(VocabularyData.self, from: data)
                print("✅ Loaded \(vocabularyData.vocabulary.count) words from JSON String")
                return vocabularyData.vocabulary
            } catch {
                print("❌ Error decoding vocabulary: \(error)")
                return []
            }
        }
}
