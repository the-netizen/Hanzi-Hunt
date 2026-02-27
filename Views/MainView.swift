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
        if !searchText.isEmpty {
            isSearchFieldFocused = false
            showingSearch = true
        }
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                VStack(spacing: 0){
                    VStack {
                        HStack{
                            //Logo image will be here
                            
                            Spacer()
                            
                            // Searchbar
                            HStack{
                                SearchBar(
                                    searchText: $searchText,
                                    placeholder: "Find words",
                                    onSubmit: {
                                        performSearch()
                                    },
                                    onClear: {
                                        searchText = ""
                                    }
                                )
                                .focused($isSearchFieldFocused)
                            }
                            .frame(width: 150)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .animation(.easeInOut(duration: 0.3), value: isSearchFieldFocused)
                            .onTapGesture {
                                isSearchFieldFocused = true //focus when tapped
                            }
                            
                        }//header hstack
                        .padding(.horizontal, 25)
                    }//header v
                    .padding(.vertical, 20)
//                    .background(Color(red: 50/255, green: 60/255, blue: 69/255))
                    .background(Color(red: 79/255, green: 89/255, blue: 114/255))
                    .zIndex(1) // Keep header above other content
                    
                    
                    ZStack(alignment: .bottom) {
                        VStack {
                            Text("Your collection")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            GalleryGrid(viewModel: viewModel, onTap: { _ in })
                        }
                        .padding(.top, 80)
                        
                        // Camera Button on top
                        Button {
                            showingCamera = true
                        } label: {
                            ZStack {
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
                        .padding(.bottom, 50)
                    }
                    .background(Color(red: 79/255, green: 89/255, blue: 114/255))
                }
                // -- tap outside to dismiss focus/keyboard
                .contentShape(Rectangle())
                .onTapGesture {
                    isSearchFieldFocused = false
                }
            }//geometry
            .ignoresSafeArea(.keyboard, edges: .bottom) // Prevent automatic keyboard avoidance
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
        }//nav
    }//body
    }
