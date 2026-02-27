import SwiftUI

struct WordCardCollected: View {
    let word: CollectedWord
    
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Group {
                    if let image = word.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.gray
                    }
                }
            )
            .clipped()
            .overlay(
                Text(word.vocabulary.hanzi)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
            )
    }
}
