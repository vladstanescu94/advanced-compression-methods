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
                        print("Horizontal analysis level \(level)")
                        viewModel.coder.analyseHorizontally(level: level)
                        viewModel.updateWaveletImage()
                    } label: {
                        Text("H")
                    }
                    Button {
                        print("Vertical analysis level \(level)")
                        viewModel.coder.analyseVertically(level: level)
                        viewModel.updateWaveletImage()
                    } label: {
                        Text("V")
                    }
                }
                VStack {
                    Text("Synthesis")
                    Button {
                        print("Horizontal Synthesis level \(level)")
                        viewModel.coder.synthesisHorizontally(level: level)
                        viewModel.updateWaveletImage()
                    } label: {
                        Text("H")
                    }
                    Button {
                        print("Vertical Synthesis level \(level)")
                        viewModel.coder.synthesisVertically(level: level)
                        viewModel.updateWaveletImage()
                    } label: {
                        Text("V")
                    }
                }
            }
        }
    }
}
