import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Advanced Compression Methods")
                .font(.largeTitle)
                .padding()
            Text("Select Encoder to get started")
                .font(.headline)
                .padding(.bottom)
            Spacer()
            Text("Stanescu Vlad 2021")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
    }
}
