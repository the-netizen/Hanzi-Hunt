import SwiftUI

struct WordCardView: View {
    let pinyin: String
    let hanzi: String
    let english: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(pinyin)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 25))
            
            Text(hanzi)
                .font(.system(size: 100))
                .foregroundColor(.white)
            
            Text(english)
                .font(.title)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(width: 300, height: 300)
        .background(Color(red: 79/255, green: 89/255, blue: 114/255))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.black, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, y: 15)
    }
}

#Preview {
    WordCardView(pinyin: "ren", hanzi: "人", english: "Person")
}
