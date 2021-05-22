//
//  HomeView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Button(action: testStuff, label: {
                Text("Button")
            })
        }
        .frame(width: 400, height: 400, alignment: .center)
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
