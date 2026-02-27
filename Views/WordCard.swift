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
                // helper text should only appear first time user is tracing- in future
                if viewModel.canShowTracingInstructions {
                    Text("Trace the hanzi to collect this word")
                        .font(.subheadline)
                        .foregroundColor(Color(.white))
                        .padding(.bottom, 40)
                    
                } else if viewModel.canShowCompletionInfo {
                    Text("Tap anywhere to continue...")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBackground))
                        .padding(.bottom, 40)
                }
                
                if viewModel.canShowTracingButton {
                    Button {
                        viewModel.completeTracing()
                    } label: {
                        Text("Done")                            
                    }
                }
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
                
            }
//            .offset(y: -80) //move up
        }
    }
}

#Preview {
    WordCard(viewModel: SearchVM())
}
