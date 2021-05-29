//
//  NearLosslessView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import SwiftUI
import Cocoa

struct NearLosslessView: View {
    @ObservedObject var viewModel = NearLosslessViewModel()
    
    var body: some View {
        HStack {
            VStack {
                OriginalImageView(viewModel: viewModel)
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

struct NearLosslessView_Previews: PreviewProvider {
    static var previews: some View {
        NearLosslessView()
    }
}
