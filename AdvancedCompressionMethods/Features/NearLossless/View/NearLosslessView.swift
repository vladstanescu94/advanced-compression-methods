import SwiftUI
import Cocoa

struct NearLosslessView: View {
    @ObservedObject var viewModel = NearLosslessViewModel()
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()
                    OriginalImageView(viewModel: viewModel)
                    Spacer()
                    DecodedImageView(viewModel: viewModel)
                    Spacer()
                    ErrorMatrixView(viewModel: viewModel)
                    Spacer()
                }
                Spacer()
                NearLosslessControlsView(viewModel: viewModel)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           alignment: .topLeading)
                
            }
            Spacer()
        }
        .padding([.top, .bottom], 50)
        .padding([.leading, .trailing], 50)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
    }
}
