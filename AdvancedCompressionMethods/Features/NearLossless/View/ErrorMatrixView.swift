import SwiftUI

struct ErrorMatrixView: View {
    @ObservedObject var viewModel: NearLosslessViewModel
    
    var body: some View {
        VStack {
            Text("Error Matrix")
            if let errorImage = viewModel.errorMatrixImage {
                Image(nsImage: errorImage)
                    
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 256, height: 256)
                    .foregroundColor(.white)
            }
            Spacer()
            HStack {
                Button(action: {
                    viewModel.generateErrorMatrixImage()
                }, label: {
                    Text("Generate Error Matrix image")
                })
            }
            Spacer()
        }
    }
}
