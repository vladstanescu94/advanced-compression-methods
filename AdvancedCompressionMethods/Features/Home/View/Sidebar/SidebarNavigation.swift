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
                destination: WaveletView(),
                tag: 3,
                selection: $selectedItem,
                label: {Text("Wavelet")})
        }.listStyle(SidebarListStyle())
        .frame(minWidth: 200,
               maxHeight: .infinity,
               alignment: .topLeading)
    }
}
