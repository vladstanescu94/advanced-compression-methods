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
