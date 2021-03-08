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

func testStuff() {
    
    let bitWriter = BitWriter(
        fileService: FileService(
            fileName: "test.txt",
            fileMode: .write))
    
        bitWriter.writeBit(bit: 1)
        bitWriter.writeBit(bit: 0)
        bitWriter.writeBit(bit: 1)
        bitWriter.writeBit(bit: 0)
        bitWriter.writeBit(bit: 0)
        bitWriter.writeBit(bit: 0)
        bitWriter.writeBit(bit: 1)
//        bitWriter.writeBit(bit: 1)
    
    let bitReader = BitReader(fileService: FileService(fileName: "test.txt", fileMode: .read))
    let bitWriter2 = BitWriter(fileService: FileService(fileName: "test2.txt", fileMode: .write))
    
    for _ in 0..<8 {
        bitWriter2.writeBit(bit: bitReader.ReadBit())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
