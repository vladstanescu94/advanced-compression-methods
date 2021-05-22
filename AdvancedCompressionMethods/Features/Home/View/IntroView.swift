//
//  IntroView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack {
            Text("Advanced Compression Methods")
                .font(.largeTitle)
                .padding()
            Text("Select Encoder to get started")
                .font(.headline)
                .padding(.bottom)
            Text("Stanescu Vlad 2021")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
