import SwiftUI

struct WordCardCollected: View {
    let word: CollectedWord
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let image = word.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width)
                        .clipped()
                } else {
                    Color.gray // backup
                }

                Text(word.vocabulary.hanzi)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                    .padding(.bottom, 6)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}
