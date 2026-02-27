import SwiftUI

struct WordCard: View {
    @ObservedObject var viewModel: SearchVM
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    if viewModel.cameraState == .traced {
                        viewModel.animateCardToGallery()
                    }
                }
            
            VStack(spacing: 20) {
                // WordCard
                VStack(spacing: 16) {
                    WordCardView(
                        pinyin: viewModel.canShowCompletionInfo ? (viewModel.detectedWord?.pinyin ?? "") : "",
                        hanzi: viewModel.detectedWord?.hanzi ?? "",
                        english: viewModel.canShowCompletionInfo ? (viewModel.detectedWord?.english ?? "") : ""
                    )
                }
                .frame(width: 300, height: 300)
                .background(Color(red: 212/255, green: 219/255, blue: 227/255))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                
                if viewModel.canShowTracingButton {
                    Button {
                        viewModel.completeTracing()
                    } label: {
                        Text("Done Tracing ✓")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color(red: 79/255, green: 89/255, blue: 114/255))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white, lineWidth: 2)
                                )
                    }
                }
            }//vstack
        }//z
    }//body
}

#Preview {
    WordCard(viewModel: SearchVM())
}
