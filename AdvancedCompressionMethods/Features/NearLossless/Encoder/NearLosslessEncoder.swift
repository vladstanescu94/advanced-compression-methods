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
    let encodingOptions: EncodingOptions
    
    init(bitReader: BitReader, bitWriter: BitWriter, encodingOptions: EncodingOptions) {
        self.bitReader = bitReader
        self.bitWriter = bitWriter
        self.encodingOptions = encodingOptions
    }
    
    public func encode() {
//        DispatchQueue.main.async {
//            let predictor = ValuePredictor(predictorType: self.predictorType, values: [1,2,3])
//            testStuff(bitReader: self.bitReader, bitWriter: self.bitWriter)
//            print("Done with predictor \(predictor.predictorType.rawValue)")
//        }
        writeBMPHeader()
        writeEncodingOptions()
    }
    
    private func writeBMPHeader() {
        for _ in 0..<1078 {
            if let byte = bitReader.ReadNBits(numberOfBits: 8) {
                bitWriter.writeNBits(numberOfBits: 8, value: byte)
            }
        }
    }
    
    private func writeEncodingOptions() {
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.predictorType.rawValue))
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.acceptedError))
        bitWriter.writeNBits(numberOfBits: 3, value: UInt32(encodingOptions.saveMode.rawValue))
    }
}
