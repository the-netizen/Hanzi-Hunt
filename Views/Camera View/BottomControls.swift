import SwiftUI

struct BottomControls: View {
    @ObservedObject var viewModel: SearchVM
    @Binding var showingHelp: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            HStack {
                // Gallery icon
                Button { viewModel.showingGallery = true } label: {
                    ZStack {
                        if let lastCollected = viewModel.collectedWordsWithImages.last {
                            WordCardCollected(word: lastCollected)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 60, height: 60)
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                }
                .padding(.leading, 50)
                
                Spacer()
                
                // Capture button
                Button { viewModel.captureObject() } label: {
                    ZStack {
                        Circle().fill(Color.gray).frame(width: 75, height: 75)
                        Circle().fill(Color.white).frame(width: 65, height: 65)
                    }
                }
                .disabled(!viewModel.canCapture)
                .opacity(viewModel.canCapture ? 1.0 : 0.5)
                
                Spacer()
                
                // Help button
                Button { showingHelp.toggle() } label: {
                    Image(systemName: showingHelp ? "ellipsis" : "info")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                }
                .padding(.trailing, 50)
            }
            .padding(.bottom, 80)
            .padding(.top, 20)
            .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.7))
        }
    }
}

#Preview {
    BottomControls(viewModel: SearchVM(), showingHelp: .constant(false))
}
