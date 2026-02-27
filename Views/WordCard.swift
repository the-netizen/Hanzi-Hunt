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
                // helper text - in future, should only appear first time user is tracing
                if viewModel.canShowTracingInstructions {
                    Text("Trace the hanzi to collect this word")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBackground).opacity(0.6))
                        .padding(.bottom, 40)
                    
                } else if viewModel.canShowCompletionInfo {
                    Text("Tap anywhere to continue...")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBackground).opacity(0.6))
                        .padding(.bottom, 40)
                }
                
                if viewModel.canShowTracingButton {
                    Button {
                        viewModel.completeTracing()
                    } label: {
                        Text("Simulate Tracing Complete")
                            
                    }
                }
                // Card
                VStack(spacing: 16) {
                    // pinyin
                    Text(viewModel.canShowCompletionInfo ? (viewModel.detectedWord?.pinyin ?? "") : "")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.canShowCompletionInfo ? .primary : .clear)
                    
                    // hanzi
                    Text(viewModel.detectedWord?.hanzi ?? "")
                        .font(.system(size: 100))
                        .foregroundColor(.primary)
                    
                    // translation
                    Text(viewModel.canShowCompletionInfo ? (viewModel.detectedWord?.english ?? "") : "")
                        .font(.headline)
                        .foregroundColor(viewModel.canShowCompletionInfo ? .secondary : .clear)
                }
                .frame(width: 300, height: 300)
                .background(Color(red: 212/255, green: 219/255, blue: 227/255))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                
            }
            .offset(y: -80) //move up
        }
    }
}

#Preview {
    WordCard(viewModel: SearchVM())
}