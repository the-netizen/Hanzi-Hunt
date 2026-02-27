import Foundation
import SwiftUI

struct GalleryGrid: View {
    @ObservedObject var viewModel: SearchVM
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    let minimumSlots = 15
    
    var emptySlotCount: Int {
        max(0, minimumSlots - viewModel.collectedWordsWithImages.count)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(viewModel.collectedWordsWithImages) { word in
                    WordCardCollected(word: word)
                }
                
                ForEach(0..<emptySlotCount, id: \.self) { _ in
                    emptySlot
                }
            }
        }
    }
    
    private var emptySlot: some View {
        Rectangle()
            .fill(.white.opacity(0.5))
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(Color.black.opacity(0.15))
            )
    }
}

struct GalleryView: View {
    @ObservedObject var viewModel: SearchVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    // back button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 32, height: 32)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.top, 25)
                .padding(.bottom, 10)
            }//v - header
            .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.8))
            
            GalleryGrid(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden()
        .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.8))
    }
}

#Preview {
    GalleryView(viewModel: SearchVM())
}
