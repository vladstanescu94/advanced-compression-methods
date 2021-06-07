//
//  WaveletRightControls.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import SwiftUI

struct WaveletRightControls: View {
    @ObservedObject var viewModel: WaveletViewModel
    
    var body: some View {
        VStack {
            LevelControls(viewModel: viewModel, level: 1)
            LevelControls(viewModel: viewModel, level: 2)
            LevelControls(viewModel: viewModel, level: 3)
            LevelControls(viewModel: viewModel, level: 4)
            LevelControls(viewModel: viewModel, level: 5)
            
            VStack {
                Button {
                    viewModel.analyzeXLevels()
                } label: {
                    Text("Analysis levels")
                }
                
                Button {
                    viewModel.synthesiseXLevels()
                } label: {
                    Text("Synthesis levels")
                }
                
                Picker(selection: $viewModel.numberOfLevels, label: Text("Levels :"), content: {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                })
                .frame(maxWidth: 300)
            }
            .padding([.top], 50)
        }
    }
}
