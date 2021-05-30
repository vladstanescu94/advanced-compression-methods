//
//  NearLosslessDecoder.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import Foundation

final class NearLosslessDecoder {
    let bitReader: BitReader
    let bitWriter: BitWriter
    
    init(bitReader: BitReader, bitWriter: BitWriter) {
        self.bitReader = bitReader
        self.bitWriter = bitWriter
    }
    
    public func decode() {
        copyHeader()
        if let options = getOptions() {
            let errorMatrix = readErrorMatrix()
            let codesMatrix = getCodes(from: errorMatrix, with: options)
            writePixelData(from: codesMatrix)
        }
    }
    
    private func copyHeader() {
        for _ in 0..<1078 {
            if let byte = bitReader.ReadNBits(numberOfBits: 8) {
                bitWriter.writeNBits(numberOfBits: 8, value: UInt32(byte))
            }
        }
    }
    
    private func getOptions() -> EncodingOptions? {
        if let predictoryType = bitReader.ReadNBits(numberOfBits: 4),
           let acceptedError = bitReader.ReadNBits(numberOfBits: 4),
           let saveMode = bitReader.ReadNBits(numberOfBits: 3) {
            let options = EncodingOptions(
                predictorType: PredictorType.init(rawValue: Int(predictoryType))!,
                saveMode: ImageSaveMode.init(rawValue: Int(saveMode))!,
                acceptedError: Int(acceptedError))
            
            return options
        }
        
        return nil
    }
    
    private func readErrorMatrix() -> [[Int]] {
        var matrix = Array(repeating: Array(repeating: 0, count: 256), count: 256)
        
        for i in 0..<256 {
            for j in 0..<256 {
                let signBit = bitReader.ReadBit()
                let isNegative = signBit == 1 ? true : false
                
                if let value = bitReader.ReadNBits(numberOfBits: 8) {
                    let error = isNegative ? Int(value) * (-1) : Int(value)
                    matrix[i][j] = error
                }
            }
        }
        
        return matrix
    }
    
    private func getCodes(from errors: [[Int]], with options: EncodingOptions) -> [[UInt8]] {
        let predictor = ValuePredictor(predictorType: options.predictorType)
        var matrices = NearLosslessMatrices(width: errors[0].count, height: errors[0].count, isDecoding: true)
        matrices.quantizedErrors = errors
        matrices.predictMatrices(with: predictor, options: options)
        
        return matrices.decoded
    }
    
    private func writePixelData(from matrix: [[UInt8]]) {
        for row in stride(from: 255, through: 0, by: -1){
            for column in 0..<256 {
                bitWriter.writeNBits(numberOfBits: 8, value: UInt32(matrix[column][row]))
            }
        }
    }
}
