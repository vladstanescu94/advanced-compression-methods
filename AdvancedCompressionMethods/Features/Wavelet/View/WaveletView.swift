import SwiftUI
import Cocoa

struct WaveletView: View {
    @ObservedObject var viewModel = WaveletViewModel()
    
    var body: some View {
        VStack{
            HStack {
                WaveletOriginalImageView(viewModel: viewModel)
                Spacer()
                WaveletImageView(viewModel: viewModel)
                Spacer()
                WaveletRightControls(viewModel: viewModel)
            }
            WaveletBottomControls(viewModel: viewModel)
        }
        .padding([.top, .bottom], 50)
        .padding([.leading, .trailing], 50)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
    }
}
