import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var viewModel: SearchVM
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            CameraPreview(
                onPhotoCaptured: { image in
                    viewModel.handlePhotoCaptured(image)
                },
                shouldCapture: viewModel.shouldCapturePhoto
            )
                .ignoresSafeArea()
                .onTapGesture {
                    isSearchFocused = false
                }
            
            //hanzi
            if viewModel.canShow3DHanzi, let word = viewModel.detectedWord {
                floating3DHanzi(word: word)
            }
            
            //wordcard
            if viewModel.canShowWordCard {
                WordCard(viewModel: viewModel)
            }
            
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        // back button
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 32, height: 32)
                        }
                        
                        Spacer()
                        
                        HStack {
                            SearchBar(
                                searchText: $viewModel.cameraSearchText,
                                placeholder: "Find words",
                                onSubmit: {
                                    // On submit, select first result if available
                                    if let first = viewModel.cameraSearchResults.first {
                                        viewModel.selectWord(first)
                                    }
                                    isSearchFocused = false //dismiss keyboard
                                },
                                onClear: {
                                    viewModel.clearCameraSearch()
                                }
                            )
                            .focused($isSearchFocused)
                            .onChange(of: viewModel.cameraSearchText) { newValue in
                                viewModel.updateCameraSearch(newValue)
                            }
                        }
                        .frame(width: 150)
                        .cornerRadius(20)
                    }//back and search
                    .padding(.horizontal, 25)
                    .padding(.top, 80)
                    .padding(.bottom, 10)
                }//v - header
                .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.8))
                .zIndex(1)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
                
                if viewModel.showingCameraSearchResults{
                    SearchResultsOverlay(viewModel: viewModel)
                        .contentShape(Rectangle())
                        .frame(height: 200)
                }
                Spacer()
                
                if viewModel.canShowSelectionScroll {
                    objectSelectionScroll //scroll
                }
                bottomControls
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showingGallery) {
            GalleryView(viewModel: viewModel)
        }
    }
    
    func floating3DHanzi(word: Vocabulary) -> some View {
        VStack(spacing: 8) {
            // hints
            Text("Capture the hanzi")
                .font(.subheadline)
                .foregroundColor(Color(.white).opacity(0.7))
                .padding(.bottom, 40)
            
            Text(word.hanzi)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.black)
            
                // stroke borders effect
                .shadow(color: .white, radius: 1, x: 1, y: 1)
                .shadow(color: .white, radius: 1, x: -1, y: -1)
                .shadow(color: .white, radius: 1, x: 1, y: -1)
                .shadow(color: .white, radius: 1, x: -1, y: 1)

                // shadow
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            
        }
        .padding(.bottom, 80)
//        .offset(y: -100) //little up
    }

    
    var objectSelectionScroll: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(Vocabulary.quickSelectObjects, id: \.self) { object in
                    ObjectButton(objectName: object,
                                 isSelected: viewModel.detectedWord?.object == object) {
                        viewModel.selectObject(object)
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    private var bottomControls: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            HStack {
                
                // Gallery icon
                Button {
                viewModel.showingGallery = true
            } label: {
                ZStack {
                    if let lastCollected = viewModel.collectedWordsWithImages.last {
                        WordCardCollected(word: lastCollected)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.black).opacity(0.5), lineWidth: 1)
                )
            }
            .padding(.leading, 50)
            
            Spacer()
            
            // Capture button
            Button {
                viewModel.captureObject()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 75, height: 75)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                }
            }
            .disabled(!viewModel.canCapture)
            .opacity(viewModel.canCapture ? 1.0 : 0.5)
            
            Spacer()
            
            // extra for now
            Button {
            } label: {
                Image(systemName: "square.grid.3x3")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color(.black).opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.trailing, 50)
        }
        .padding(.bottom, 80)
        .padding(.top, 20)
        .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.7))
        }
    }

    struct ObjectButton: View{
        let objectName: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View{
            Button {
                action()
            } label: {
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
}

 #Preview {
     CameraView(viewModel: SearchVM())
 }
