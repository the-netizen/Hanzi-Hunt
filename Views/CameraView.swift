import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: SearchVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.gray
            
            if viewModel.shouldShow3DHanzi, let word = viewModel.detectedWord {
                floating3DHanzi(word: word)
            }
            
            if viewModel.shouldShowWordCard {
                wordCard
            }
            VStack {
                Spacer()
                bottomControls
            }
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $viewModel.showingGallery) {
            GalleryView(viewModel: viewModel)
        }
        .onAppear {
            // Simulate detection for testing
            viewModel.simulateDetection()
        }
    }
    
    private func floating3DHanzi(word: Vocabulary) -> some View {
        VStack(spacing: 8) {
            // hints
            Text("Tap to capture")
                .font(.subheadline)
                .foregroundColor(Color(.systemBackground).opacity(0.8))
                .padding(.bottom, 40)
            
            Text(word.hanzi)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.black)
            
                // stroke borders effect
                .shadow(color: .white, radius: 1, x: 1, y: 1)
                .shadow(color: .white, radius: 1, x: -1, y: -1)
                .shadow(color: .white, radius: 1, x: 1, y: -1)
                .shadow(color: .white, radius: 1, x: -1, y: 1)

                // shadow
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            
        }
        .offset(y: -100) //little up
    }
    
    private var wordCard: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    if viewModel.cameraState == .traced {
                        viewModel.animateCardToGallery()
                    }
                }
            
            VStack(spacing: 20) {
                // helper text - in future, should only appear first time user is tracing
                if viewModel.shouldShowTracingInstructions {
                    Text("Trace the hanzi to collect this word")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBackground).opacity(0.6))
                        .padding(.bottom, 40)
                    
                } else if viewModel.shouldShowCompletionInfo {
                    Text("Tap anywhere to continue...")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBackground).opacity(0.6))
                        .padding(.bottom, 40)
                }
                
                if viewModel.shouldShowTracingButton {
                    Button {
                        viewModel.completeTracing()
                    } label: {
                        Text("Simulate Tracing Complete")
                            
                    }
                }
                // Card
                VStack(spacing: 16) {
                    // pinyin
                    Text(viewModel.shouldShowCompletionInfo ? (viewModel.detectedWord?.pinyin ?? "") : "")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.shouldShowCompletionInfo ? .primary : .clear)
                    
                    // hanzi
                    Text(viewModel.detectedWord?.hanzi ?? "")
                        .font(.system(size: 100))
                        .foregroundColor(.primary)
                    
                    // translation
                    Text(viewModel.shouldShowCompletionInfo ? (viewModel.detectedWord?.english ?? "") : "")
                        .font(.headline)
                        .foregroundColor(viewModel.shouldShowCompletionInfo ? .secondary : .clear)
                }
                .frame(width: 300, height: 300)
                .background(Color(red: 212/255, green: 219/255, blue: 227/255))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                
            }
            .offset(y: -80) //move up
        }
    }
    
    private var bottomControls: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            HStack {
                
                // Gallery
                Button {
                viewModel.showingGallery = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 60, height: 60)
                    
                    if let lastCollected = viewModel.collectedWords().last {
                        VStack(spacing: 2) {
                            Text(lastCollected.hanzi)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.black).opacity(0.5), lineWidth: 1)
                )
            }
            .padding(.leading, 50)
            
            Spacer()
            
            // Capture button
            Button {
                viewModel.captureObject()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 75, height: 75)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                }
            }
            .disabled(!viewModel.canCapture)
            .opacity(viewModel.canCapture ? 1.0 : 0.5)
            
            Spacer()
            
            // extra for now
            Button {
            } label: {
                Image(systemName: "square.grid.3x3")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color(.black).opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.trailing, 50)
        }
        .padding(.bottom, 80)
        .padding(.top, 20)
        .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.8))
        }
    }
    
}

#Preview {
    CameraView(viewModel: SearchVM())
}
