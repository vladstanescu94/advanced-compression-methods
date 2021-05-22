//
//  HomeView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import SwiftUI

struct HomeView: View {
    @State var selectedItem: Int? = 1
    var body: some View {
        NavigationView {
            SidebarNavigation(selectedItem: $selectedItem)
            IntroView()
        }
        .frame(width: WindowSize.width.rawValue,
               height: WindowSize.height.rawValue,
               alignment: .center)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(PreviewLayout.fixed(width: 800, height: 600))
    }
}
