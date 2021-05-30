//
//  NearLosslessEncoder.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import Foundation
import Cocoa

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
        guard let imageBytes = bitReader.getFileByteData() else { return }
        let imageData = Data(bytes: imageBytes, count: imageBytes.count)
        
        if let imageRep = NSBitmapImageRep(data: imageData) {
            var imageMatrices = NearLosslessMatrices(image: imageRep)
            let predictor = ValuePredictor(predictorType: encodingOptions.predictorType)
            
            imageMatrices.predictMatrices(with: predictor, options: encodingOptions)
            
            writeBMPHeader(from: imageBytes)
            writeEncodingOptions()

            writeErrorMatrix(matrix: imageMatrices.quantizedErrors)
        }
    }
    
    private func writeBMPHeader(from bytes: [UInt8]) {
        guard bytes.count > 1078 else { return }
        
        for i in 0..<1078 {
            let byte = bytes[i]
            bitWriter.writeNBits(numberOfBits: 8, value: UInt32(byte))
        }
    }
    
    private func writeEncodingOptions() {
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.predictorType.rawValue))
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.acceptedError))
        bitWriter.writeNBits(numberOfBits: 3, value: UInt32(encodingOptions.saveMode.rawValue))
    }
    
    private func writeErrorMatrix(matrix: [[Int]]) {
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                let value = matrix[i][j]
                let isNegative = value < 0
                let absValue = abs(value)
                bitWriter.writeBit(bit: isNegative ? 1 : 0)
                bitWriter.writeNBits(numberOfBits: 8, value: UInt32(absValue))
            }
        }
    }
}
