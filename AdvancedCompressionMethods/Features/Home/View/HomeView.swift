//
//  HomeView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        HStack {
            SidebarNavigation()
            IntroView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
