//import Foundation
import SwiftUI

struct MuralCardView: View {
    let mural: Mural
    let vocabulary: [Vocabulary]
    
    private var progress: (collected: Int, total: Int) {
            mural.collectionProgress(vocabulary: vocabulary)
        }
    
    // SF symbols for mural images - temporary
    private func getPlaceholderSymbol(for title: String) -> String {
        switch title.lowercased() {
        case let t where t.contains("road"):
            return "road.lanes"
        case let t where t.contains("study") || t.contains("desk"):
            return "laptopcomputer"
        case let t where t.contains("park"):
            return "tree"
        case let t where t.contains("kitchen"):
            return "refrigerator"
        case let t where t.contains("classroom"):
            return "pencil.and.scribble" // Fixed: this symbol exists
        default:
            return "photo.artframe"
        }
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
            
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack{
                    Text(mural.title)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(progress.collected)/\(progress.total) words")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                Spacer()
                
                // Mural objects will be added here later
                
            }//v

            // Placeholder image using SF Symbols
            VStack {
                Image(systemName: getPlaceholderSymbol(for: mural.title))
                    .font(.system(size: 80))
                    .foregroundColor(.blue.opacity(0.6))
            }
            
        }//z
        .frame(height: 400)
        .padding(.horizontal, 20)
    }
}

#Preview {
    MuralCardView(
        mural: Mural.samples[0],
        vocabulary: Vocabulary.samples
    )
//    .padding()
}
