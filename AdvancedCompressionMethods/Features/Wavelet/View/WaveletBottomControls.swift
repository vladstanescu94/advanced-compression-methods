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
            
//            VStack {
//                HStack {
//                    Text("X Highlight: ")
//                    TextField("X Highlight", text: $viewModel.highlightXString)
//                }
//                HStack {
//                    Text("Y Highlight: ")
//                    TextField("Y Highlight", text: $viewModel.highlightYString)
//                }
//                HStack {
//                    Text("Offset: ")
//                    TextField("Offset", text: $viewModel.offsetString)
//                }
//                HStack {
//                    Text("Scale: \(viewModel.scaleValue, specifier: "%.2f") ")
//                    Slider(value: $viewModel.scaleValue, in: 0.0...5.0)
//                }
//            }
//            .frame(maxWidth: 300)
        }
    }
}
