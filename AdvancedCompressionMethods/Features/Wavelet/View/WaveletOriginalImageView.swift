//
//  WaveletOriginalImageView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import SwiftUI

struct WaveletOriginalImageView: View {
    @ObservedObject var viewModel: WaveletViewModel
    
    var body: some View {
        VStack {
            Text("Original image")
            if let image = viewModel.originalImage {
                Image(nsImage: image)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 512, height: 512)
                    .foregroundColor(.white)
            }
            Spacer()
            HStack {
                Button(action: {
                    openFileFromPanel(allowedExtensions: ["bmp"]) { url in
                        viewModel.originalImageURL = url
                        viewModel.setWaveletImage()
                        viewModel.getPixelData(from: viewModel.originalImage!)
                        viewModel.loadCoder()
                    }
                    
                }, label: {
                    Text("Load image")
                })
            }
            Spacer()
        }
    }
}
