//
//  WaveletImageView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import SwiftUI

struct WaveletImageView: View {
    @ObservedObject var viewModel: WaveletViewModel
    
    var body: some View {
        VStack {
            Text("Wavelet Image")
            if let waveletImage = viewModel.waveletImage {
                Image(nsImage: waveletImage)
            }
            else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 512, height: 512)
                    .foregroundColor(.white)
            }
            Spacer()
            HStack {
                Button(action: {
                    openFileFromPanel(allowedExtensions: ["wvl"]) { url in
                        viewModel.waveletImageURL = url
                        viewModel.decodeWaveletFile()
                    }
                }, label: {
                    Text("Load Wavelet Image")
                })
                Button(action: {
                    
                }, label: {
                    Text("Save Wavelet Image")
                })
            }
            Spacer()
        }
    }
}
