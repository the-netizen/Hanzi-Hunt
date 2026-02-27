import SwiftUI

struct WordsScroll: View {
    @ObservedObject var viewModel: SearchVM
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Vocabulary.quickSelectObjects, id: \.self) { object in
                    SuggestedWord(
                        objectName: object,
                        isSelected: viewModel.detectedWord?.object == object
                    ) {
                        viewModel.selectObject(object)
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

struct SuggestedWord: View {
    let objectName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button { action() } label: {
            Text(objectName.capitalized)
                .font(.caption)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .black.opacity(0.7))
                .background(isSelected ? Color(red: 79/255, green: 89/255, blue: 114/255) : .white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 1)
                )
        }
    }
}

#Preview {
    WordsScroll(viewModel: SearchVM())
}
