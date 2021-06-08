import SwiftUI

struct DecodedImageView: View {
    @ObservedObject var viewModel: NearLosslessViewModel
    
    var body: some View {
        VStack {
            Text("Decoded image")
            if let image = viewModel.decodedImage {
                Image(nsImage: image)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 256, height: 256)
                    .foregroundColor(.white)
            }
            Spacer()
            HStack {
                Button(action: {
                    openFileFromPanel(allowedExtensions: ["prd"]) { url in
                        viewModel.encodedFileURL = url
                        viewModel.decodedImageURL = nil
                    }
                }, label: {
                    Text("Load encoded file")
                })
                Button(action: {
                    DispatchQueue.main.async {
                        viewModel.decode()
                    }
                }, label: {
                    Text("Decode")
                })
            }
            Spacer()
        }
    }
}
