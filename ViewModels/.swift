import ARKit
import RealityKit
import UIKit

@MainActor
class ARCamera: NSObject, ObservableObject {
    
    // AR Session
    private var arView: ARView?
    private let session = ARSession()
    
    // Detection callback
    var onObjectDetected: ((String) -> Void)?
    
    // Available objects to detect (shown as buttons)
    let detectableObjects = [
        "cup", "laptop", "book", "person", "chair",
        "phone", "dog", "cat", "tree", "car"
    ]
    
    // Currently selected object
    @Published var selectedObject: String?
    
    // MARK: - Setup
    
    func setupAR(for arView: ARView) {
        self.arView = arView
        arView.session = session
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = []
        session.run(configuration)
        
        print("✅ AR Camera ready - manual object selection mode")
    }
    
    // MARK: - Manual Detection
    
    /// User manually selects what object they're pointing at
    func selectObject(_ objectName: String) {
        selectedObject = objectName
        print("🔍 User selected: \(objectName)")
        onObjectDetected?(objectName)
    }
    
    // MARK: - Cleanup
    
    func pause() {
        session.pause()
    }
    
    func resume() {
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
    }
}
