//
//  NearLosslessEncoder.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import Foundation

class NearLosslessEncoder {
    let bitReader: BitReader
    let bitWriter: BitWriter
    
    init(bitReader: BitReader, bitWriter: BitWriter) {
        self.bitReader = bitReader
        self.bitWriter = bitWriter
    }
    
    public func encode() {
        DispatchQueue.main.async {
            testStuff(bitReader: self.bitReader, bitWriter: self.bitWriter)
            print("Done")
        }
    }
}
