import SwiftUI
import PencilKit

struct ContentView: View {
    @State var paperViewModel = PaperViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Text(paperViewModel.textResult)
                Spacer()
                HStack {
                    Button("recognise text") {
                        paperViewModel.shouldRecognise = true
                    }
                    Spacer()
                }
                .padding(24)

                Spacer()

                PaperView(viewModel: paperViewModel)
                    .overlay { 
                        VStack {
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    paperViewModel.isShowToolPicker.toggle()
                                }, label: {
                                    Image(systemName: "pencil.tip")
                                })
                                .buttonStyle(IconButton())
                                
                                Button(action: {
                                    paperViewModel.resetPaper()
                                }, label: {
                                    Image(systemName: "trash")
                                })
                                .buttonStyle(IconButton())
                            }
                            .padding(.horizontal, 48)
                            Spacer()
                        }
                    }
            }
        }
    }
}
