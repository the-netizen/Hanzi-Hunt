import SwiftUI

struct UIComponents: View {
    @ObservedObject var viewModel: SearchVM
    let dismiss: () -> Void
    var isSearchFocused: FocusState<Bool>.Binding
    @Binding var showingHelp: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CameraHeader(
                viewModel: viewModel,
                dismiss: dismiss,
                isSearchFocused: isSearchFocused
            )
            
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
            
            if viewModel.showingCameraSearchResults {
                SearchResultsOverlay(viewModel: viewModel)
                    .contentShape(Rectangle())
                    .frame(height: 200)
            }
            
            if showingHelp {
                helpOverlay
                    .onTapGesture { showingHelp = false }
            }
            
            Spacer()
            
            if viewModel.canShowSelectionScroll {
                WordsScroll(viewModel: viewModel)
            }
            
            BottomControls(
                viewModel: viewModel,
                showingHelp: $showingHelp
            )
        }
    }
    struct CameraHeader: View {
        @ObservedObject var viewModel: SearchVM
        let dismiss: () -> Void
        var isSearchFocused: FocusState<Bool>.Binding
        
        var body: some View {
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 32, height: 32)
                    }
                    
                    Spacer()
                    
                    SearchBar(
                        searchText: $viewModel.cameraSearchText,
                        placeholder: "Find words",
                        // On submit, select first result if available
                        onSubmit: {
                            if let first = viewModel.cameraSearchResults.first {
                                viewModel.selectWord(first)
                            }
                            isSearchFocused.wrappedValue = false //dismiss keyboard
                        },
                        onClear: { viewModel.clearCameraSearch() }
                    )
                    .focused(isSearchFocused)
                    .onChange(of: viewModel.cameraSearchText) { newValue in
                        viewModel.updateCameraSearch(newValue)
                    }
                    .frame(width: 150)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 25)
                .padding(.top, 80)
                .padding(.bottom, 10)
            }
            .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.8))
            .zIndex(1)
        }//body
    }
    
    var helpText: String {
        switch viewModel.cameraState {
        case .scanning:
            return viewModel.detectedWord == nil
                ? "Select an object from the scroll or search bar, then point your camera at it"
                : "Capture the object with camera button!"
        case .showingCard, .tracing:
            return "Trace the character with your finger, then click Done to collect it"
        case .traced:
            return "Tap anywhere to continue hunting for more words!"
        }
    }
    
    var helpOverlay: some View {
        VStack {
            Text(helpText)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color(red: 79/255, green: 89/255, blue: 114/255).opacity(0.7))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 2)
                )
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}

#Preview {
    @FocusState var isSearchFocused: Bool
    
    UIComponents(
        viewModel: SearchVM(),
        dismiss: { },
        isSearchFocused: $isSearchFocused,
        showingHelp: .constant(true)
    )
}
