//
//  AdvancedCompressionMethodsApp.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import SwiftUI

@main
struct AdvancedCompressionMethodsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .commands {
            SidebarCommands()
        }
    }
}
