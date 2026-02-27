import SwiftUI

// has SearchView, SearchBarView, SearchResultCard, SearchResultsOverlay,

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
            .background(Color(.systemBackground))
            .cornerRadius(20)
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
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    var placeholder: String
    var onSubmit: (() -> Void)?
    var onClear: (() -> Void)?
    
    init(
        searchText: Binding<String>,
        placeholder: String = "Find words",
        onSubmit: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.onClear = onClear
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                onSubmit?()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            
            TextField(placeholder, text: $searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .onSubmit {
                    onSubmit?()
                }
            
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
}

struct SearchResultsOverlay: View {
    @ObservedObject var viewModel: SearchVM
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.cameraSearchResults) { word in
                        SearchResultRow(word: word) {
                            viewModel.selectWord(word)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.black.opacity(0.6))
            
            Spacer()
        }
    }
}

struct SearchResultRow: View {
    let word: Vocabulary
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Hanzi
                Text(word.hanzi)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 50)

                // Info
//                VStack(alignment: .leading, spacing: 4) {
                    Text(word.object.capitalized)
                        .font(.headline)
                        .foregroundColor(.white)
                    
//                    HStack(spacing: 4) {
//                        Text(word.pinyin)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.7))
//                        Text("•")
//                            .foregroundColor(.white.opacity(0.5))
//                        Text(word.english)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(viewModel: SearchVM(), initialSearchText: "")
//        SearchResultsOverlay(viewModel: SearchVM())
    }
}
