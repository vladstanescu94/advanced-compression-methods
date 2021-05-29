//
//  OriginalImageView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 29.05.2021.
//

import SwiftUI

struct OriginalImageView: View {
    @ObservedObject var viewModel: NearLosslessViewModel
    
    var body: some View {
        VStack {
            Text("Original image")
            if let image = viewModel.originalImage {
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
                    openFileFromPanel(allowedExtensions: ["bmp"]) { url in
                        viewModel.originalImageURL = url
                    }
                }, label: {
                    Text("Load image")
                })
                Button(action: {
                    viewModel.encoder.encode(imageToEncode: viewModel.originalImageURL)
                }, label: {
                    Text("Encode")
                })
            }
            Spacer()
        }
    }
}
