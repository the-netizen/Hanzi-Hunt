import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let onPhotoCaptured: (UIImage) -> Void
    let shouldCapture: Bool
    
    class CameraView: UIView {
        var session: AVCaptureSession?
        var photoOutput: AVCapturePhotoOutput?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var photoCallback: ((UIImage) -> Void)?
        var currentHandler: PhotoHandler?
        var lastCaptureTime: Date?
        var frozenImageView: UIImageView?

        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupCamera()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupCamera() {
            let session = AVCaptureSession()
            session.sessionPreset = .photo
            
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device) else {
                return
            }
            
            session.addInput(input)
            
            let output = AVCapturePhotoOutput()
            session.addOutput(output)
            self.photoOutput = output
            
            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = .resizeAspectFill
            preview.frame = bounds
            layer.addSublayer(preview)
            self.previewLayer = preview
            
            self.session = session
            session.startRunning()
        }
        
        func capturePhoto() {
            // Prevent multiple captures within 1 second
            if let last = lastCaptureTime, Date().timeIntervalSince(last) < 1.0 {
                return
            }
            
            guard let photoOutput = photoOutput, let callback = photoCallback else { return }
            
            lastCaptureTime = Date()
            print("📸 Taking photo...")
            
            let settings = AVCapturePhotoSettings()
            let handler = PhotoHandler(callback: callback)
            self.currentHandler = handler  // Keep strong reference
            photoOutput.capturePhoto(with: settings, delegate: handler)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }
    
    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.photoCallback = onPhotoCaptured
        context.coordinator.cameraView = view
        return view
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {
        if shouldCapture {
            uiView.capturePhoto()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var cameraView: CameraView?
    }
}

class PhotoHandler: NSObject, AVCapturePhotoCaptureDelegate, @unchecked Sendable{
    let callback: (UIImage) -> Void
    
    init(callback: @escaping (UIImage) -> Void) {
        self.callback = callback
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            //testing
            print("❌ Failed to capture image")
            return
        }
        
        print("✅ Photo captured! Size: \(image.size)")
        let callback = self.callback
        DispatchQueue.main.async {
            callback(image)
        }
    }
}
