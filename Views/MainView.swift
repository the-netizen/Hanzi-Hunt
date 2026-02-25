import Foundation
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = SearchVM()
    @State private var searchText = ""
    @State private var showingSearch = false
    @State private var showingCamera = false
    @State private var showingGallery = false
    @FocusState private var isSearchFieldFocused: Bool
    
    private func performSearch() {
//        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchText.isEmpty {
            isSearchFieldFocused = false
            showingSearch = true
        }
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    VStack {
                        HStack{
                            // Gallery button
                            Button{
                                showingGallery = true
                            }label: {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .foregroundStyle(Color(.white))
                                    .frame(width: 30, height: 30)
                            }
                            Spacer()
                            
                            // Searchbar
                            HStack{
                                TextField("Find words", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .focused($isSearchFieldFocused)
                                    .onSubmit {
                                        performSearch()
                                    }
                                
                                Button {
                                    performSearch()
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 150)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .animation(.easeInOut(duration: 0.3), value: isSearchFieldFocused)
                            .onTapGesture {
                                isSearchFieldFocused = true //focus when tapped
                            }
                            
                        }//header
                        .padding(.horizontal, 25)
                        .padding(.top, 20)
                    }
                    .background(Color(red: 50/255, green: 60/255, blue: 69/255))
                    .zIndex(1) // Keep header above other content
                    
                        VStack {
                            Spacer()
                                .frame(height: 50)
                            
                            // Murals
                            VStack(alignment: .leading){
                                Text("Collections")
                                    .foregroundStyle(Color(.white))
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                TabView { //page controls
                                        ForEach(viewModel.murals) { mural in
                                            MuralCardView(
                                                mural: mural,
                                                vocabulary: viewModel.allVocabulary
                                            )
                                            .padding(.horizontal, 20)
                                        }
                                    }
                                    .tabViewStyle(.page(indexDisplayMode: .always))
                                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                                    .frame(height: 500)
                            }
                            
                            Spacer()
                                .frame(height: 50)
                            
                            // Camera Button
                            Button{
                                showingCamera = true
                            }label: {
                                ZStack{
                                    Circle()
                                        .fill(Color(.systemBackground))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Circle()
                                                .stroke(.black, lineWidth: 2)
                                        )
                                    Image(systemName: "camera")
                                        .foregroundStyle(Color.primary)
                                        .font(.system(size: 32))
                                }
                            }
                            
                            Spacer()
                                .frame(height: 100) // Extra bottom padding for keyboard
                        }
                    .background(Color(red: 50/255, green: 60/255, blue: 69/255))
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // Prevent automatic keyboard avoidance
            .navigationDestination(isPresented: $showingGallery) {
                GalleryView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showingCamera) {
                CameraView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showingSearch) {
                SearchView(viewModel: viewModel, initialSearchText: searchText)
            }
            .onChange(of: showingSearch) { newValue in
                if !newValue {
                    searchText = "" // Clear search
                }
            }
        }
    }
}
