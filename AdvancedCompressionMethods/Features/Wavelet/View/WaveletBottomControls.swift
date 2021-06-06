//
//  WaveletBottomControls.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import SwiftUI

struct WaveletBottomControls: View {
    @ObservedObject var viewModel: WaveletViewModel
    
    var body: some View {
        HStack(spacing: 300) {
            HStack {
                Button {
                    viewModel.testErrors()
                } label: {
                    Text("Test errors")
                }
                
                VStack {
                    Text("Min error \(viewModel.minError ?? 0.0)")
                    Text("Max error \(viewModel.maxError ?? 0.0)")
                }
            }
            
            VStack {
                HStack {
                    Text("Highlight X: \(viewModel.highlightXValue, specifier: "%.2f") ")
                    Slider(value: $viewModel.highlightXValue, in: 0.0...512.0, step: 16.0)
                }
                HStack {
                    Text("Highlight Y: \(viewModel.highlightYValue, specifier: "%.2f") ")
                    Slider(value: $viewModel.highlightYValue, in: 0.0...512.0, step: 16.0)
                }
                HStack {
                    Text("Offset: \(viewModel.offsetValue, specifier: "%.2f") ")
                    Slider(value: $viewModel.offsetValue, in: 0.0...128.0)
                }
                HStack {
                    Text("Scale: \(viewModel.scaleValue, specifier: "%.2f") ")
                    Slider(value: $viewModel.scaleValue, in: 0.0...5.0)
                }
                Button {
                    viewModel.updateWaveletImage()
                } label: {
                    Text("Update Image")
                }

            }
            .frame(maxWidth: 300)
        }
    }
}
