import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchVM
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    let initialSearchText: String
    
    init(viewModel: SearchVM, initialSearchText: String = "") {
        self.viewModel = viewModel
        self.initialSearchText = initialSearchText
    }
    
    var searchResults: [Vocabulary] {
        viewModel.search(query: searchText)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search by hanzi, pinyin, or English", text: $searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
            
            // Results
            if searchText.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Search for Chinese words")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Try: \"人\", \"ren\", or \"person\"")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            }
            else if searchResults.isEmpty {
                VStack(spacing: 16) {
                    Text("No words found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Try a different search term")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            }
            else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(searchResults) { word in
                            SearchResultCard(word: word)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Find Words")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            if !initialSearchText.isEmpty {
                searchText = initialSearchText
            }
        }
    }
}

struct SearchResultCard: View {
    let word: Vocabulary
    
    var body: some View {
        HStack(spacing: 20) {
            // Hanzi
            Text(word.hanzi)
                .font(.system(size: 35))
                .frame(width: 100)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(word.pinyin)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(word.english)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if word.isCollected {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Collected")
                    }
                    .font(.caption)
                    .foregroundColor(.green)
                }
            }
            
            Spacer()
            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray.opacity(0.5))
            // go to WordCardView
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    NavigationStack {
        SearchView(viewModel: SearchVM(), initialSearchText: "")
    }
}
