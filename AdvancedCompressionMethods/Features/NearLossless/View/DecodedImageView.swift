//
//  DecodedImageView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

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
                    }
                }, label: {
                    Text("Load encoded file")
                })
                Button(action: {
                    viewModel.decode()
                }, label: {
                    Text("Decode")
                })
            }
            Spacer()
        }
    }
}
