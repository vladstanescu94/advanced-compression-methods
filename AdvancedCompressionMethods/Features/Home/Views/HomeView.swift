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
    let bitReader = BitReader(fileService: FileService(fileName: "test.txt", fileMode: .read))
    let bitWriter = BitWriter(fileService: FileService(fileName: "test2.txt", fileMode: .write))
    
    guard let service = bitReader.fileService as? FileService else { return }
    
    var NBR = 8 * service.fileSize
    
    repeat {
        var nb = Int.random(in: 1...32)
        
        if nb > NBR {
            nb = Int(NBR)
        }
        
        guard let value = bitReader.ReadNBits(numberOfBits: nb) else { return }
        bitWriter.writeNBits(numberOfBits: nb, value: value)
        NBR -= UInt64(nb)
    } while NBR > 0
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
