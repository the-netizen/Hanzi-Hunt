import SwiftUI

struct FloatingHanzi: View {
    let word: Vocabulary
    
    var body: some View {
        VStack(spacing: 8) {
            Text(word.hanzi)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.black)
                
                // stroke borders effect
                .shadow(color: .white, radius: 1, x: 1, y: 1)
                .shadow(color: .white, radius: 1, x: -1, y: -1)
                .shadow(color: .white, radius: 1, x: 1, y: -1)
                .shadow(color: .white, radius: 1, x: -1, y: 1)
            
                //shadow
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .padding(.bottom, 80)
    }
}
