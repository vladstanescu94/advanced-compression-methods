//
//  NearLosslessView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import SwiftUI

struct NearLosslessView: View {
    @ObservedObject var encoder = NearLosslessEncoder()
    @ObservedObject var decoder = NearLosslessDecoder()
    
    var body: some View {
        HStack {
            Button(action: encoder.encode, label: {
                Text("Encode")
            })
            
            Button(action: decoder.decode, label: {
                Text("Decode")
            })
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
    }
}

struct NearLosslessView_Previews: PreviewProvider {
    static var previews: some View {
        NearLosslessView()
    }
}
