//
//  SidebarNavigation.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import SwiftUI

struct SidebarNavigation: View {
    @Binding var selectedItem: Int?
    
    var body: some View {
        List {
            NavigationLink(
                destination: IntroView(),
                tag: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/,
                selection: $selectedItem,
                label: {Text("Home")})
            NavigationLink(
                destination: NearLosslessView(),
                tag: 2,
                selection: $selectedItem,
                label: {Text("Near Lossless")})
            NavigationLink(
                destination: Text("Fractal"),
                tag: 3,
                selection: $selectedItem,
                label: {Text("Fractal")})
        }.listStyle(SidebarListStyle())
        .frame(minWidth: 200,
               maxHeight: .infinity,
               alignment: .topLeading)
    }
}

struct SidebarNavigation_Previews: PreviewProvider {
    @State static var selectedItem: Int? = 1
    static var previews: some View {
        SidebarNavigation(selectedItem: $selectedItem)
    }
}
