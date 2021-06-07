//
//  LevelControls.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import SwiftUI

struct LevelControls: View {
    @ObservedObject var viewModel: WaveletViewModel
    var level: Int
    
    var body: some View {
        VStack {
            Text("Level \(level)")
            HStack {
                VStack {
                    Text("Analysis")
                    Button {
                        DispatchQueue.main.async {
                            viewModel.coder.analyseHorizontally(level: level)
                            viewModel.halveHighlightYValue()
                            viewModel.updateWaveletImage()
                        }
                    } label: {
                        Text("H")
                    }
                    Button {
                        DispatchQueue.main.async {
                            viewModel.coder.analyseVertically(level: level)
                            viewModel.halveHighlightXValue()
                            viewModel.updateWaveletImage()
                        }
                    } label: {
                        Text("V")
                    }
                }
                VStack {
                    Text("Synthesis")
                    Button {
                        DispatchQueue.main.async {
                            viewModel.coder.synthesisHorizontally(level: level)
                            viewModel.doubleHighlightYValue()
                            viewModel.updateWaveletImage()
                        }
                    } label: {
                        Text("H")
                    }
                    Button {
                        DispatchQueue.main.async {
                            viewModel.coder.synthesisVertically(level: level)
                            viewModel.doubleHighlightXValue()
                            viewModel.updateWaveletImage()
                        }
                    } label: {
                        Text("V")
                    }
                }
            }
        }
    }
}
