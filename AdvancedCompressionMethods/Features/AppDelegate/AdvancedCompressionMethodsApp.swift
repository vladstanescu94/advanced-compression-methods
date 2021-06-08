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
