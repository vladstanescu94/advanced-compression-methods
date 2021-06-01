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
            
            imageMatrices.predictMatrices(with: predictor, acceptedError: encodingOptions.acceptedError)
            
            writeBMPHeader(from: imageBytes)
            writeEncodingOptions()

            writeErrorMatrix(matrix: imageMatrices.quantizedErrors, saveMode: encodingOptions.saveMode)
        }
    }
    
    private func writeBMPHeader(from bytes: [UInt8]) {
        guard bytes.count > BmpConstants.headerSize.rawValue else { return }
        
        for i in 0..<BmpConstants.headerSize.rawValue {
            let byte = bytes[i]
            bitWriter.writeNBits(numberOfBits: 8, value: UInt32(byte))
        }
    }
    
    private func writeEncodingOptions() {
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.predictorType.rawValue))
        bitWriter.writeNBits(numberOfBits: 4, value: UInt32(encodingOptions.acceptedError))
        bitWriter.writeNBits(numberOfBits: 3, value: UInt32(encodingOptions.saveMode.rawValue))
    }
    
    private func writeErrorMatrix(matrix: [[Int]], saveMode: ImageSaveMode) {
        switch saveMode {
        case .arithmetic:
            writeArithmeticMatrix()
        case .fix:
            writeFixedMatrix(matrix: matrix)
        case .jpegTable:
            writeJpegTableMatrix(matrix: matrix)
        }
    }
    
    private func writeArithmeticMatrix() {
        fatalError("Not implemented")
    }
    
    private func writeFixedMatrix(matrix: [[Int]]) {
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
    
    private func writeJpegTableMatrix(matrix: [[Int]]) {
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                let value = matrix[i][j]
                writeJpegValue(value: value)
            }
        }
    }
    
    private func writeJpegValue(value: Int) {
        guard value != 0 else {
            bitWriter.writeBit(bit: 0)
            return
        }
        
        let requiredBits = getRequiredNumberOfBits(for: value)
        writeValueHeader(numberBits: requiredBits)
        writeValue(value: value, numberOfBits: requiredBits)
        
    }
    
    private func getRequiredNumberOfBits(for value: Int) -> Int {
        guard value != 0 else {
            return -1
        }
        
        let absoluteValue = abs(value)
        
        return Int(log2(Double(absoluteValue)) + 1)
    }
    
    private func writeValueHeader(numberBits: Int) {
        guard numberBits > 0 else {
            return
        }
        
        for _ in 0..<numberBits {
            bitWriter.writeBit(bit: 1)
        }
        
        bitWriter.writeBit(bit: 0)
    }
    
    private func writeValue(value: Int, numberOfBits: Int) {
        if value < 0 {
            let maxValueForBits: Int = Int(pow(2, Double(numberOfBits)) - 1)
            let valueToWrite = maxValueForBits + value
            bitWriter.writeNBits(numberOfBits: numberOfBits, value: UInt32(valueToWrite))
        } else {
            bitWriter.writeNBits(numberOfBits: numberOfBits, value: UInt32(value))
        }
    }
}
