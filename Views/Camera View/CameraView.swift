import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var viewModel: SearchVM
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool
    @State private var showingHelp = false
    
    var body: some View {
        ZStack {
            CameraPreview(
                onPhotoCaptured: { image in
                    viewModel.handlePhotoCaptured(image)
                },
                shouldCapture: viewModel.shouldCapturePhoto
            )
            .ignoresSafeArea()
            .onTapGesture { isSearchFocused = false }
            
            if viewModel.canShow3DHanzi, let word = viewModel.detectedWord {
                FloatingHanzi(word: word)
            }
            
            if viewModel.canShowWordCard {
                WordCard(viewModel: viewModel)
            }
            
            //header, search, wordCard, bottom controls
            UIComponents(
                viewModel: viewModel,
                dismiss: { dismiss() },
                isSearchFocused: $isSearchFocused,
                showingHelp: $showingHelp
            )
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showingGallery) {
            GalleryView(viewModel: viewModel)
        }
    }
}

#Preview {
    CameraView(viewModel: SearchVM())
}
