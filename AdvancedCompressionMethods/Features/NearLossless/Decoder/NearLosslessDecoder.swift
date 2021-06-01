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
    var decodedFileURL: URL? = nil
    
    init(bitReader: BitReader, bitWriter: BitWriter) {
        self.bitReader = bitReader
        self.bitWriter = bitWriter
    }
    
    public func decode() {
        copyHeader()
        if let options = getOptions() {
            let errorMatrix = readErrorMatrix(saveMode: options.saveMode)
            let codesMatrix = getCodes(from: errorMatrix, with: options)
            writePixelData(from: codesMatrix)
            if let service = bitWriter.fileService as? FileService {
                if let decodedURL =  service.fileURL {
                    self.decodedFileURL = decodedURL
                }
            }
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
    
    private func readErrorMatrix(saveMode: ImageSaveMode) -> [[Int]] {
        switch saveMode {
        case .arithmetic:
            return readArithmeticMatrix()
        case .fix:
            return readFixedMatrix()
        case .jpegTable:
            return readJpegTableMatrix()
        }
    }
    
    private func readArithmeticMatrix() -> [[Int]] {
        fatalError("Not implemented")
    }
    
    private func readFixedMatrix() -> [[Int]] {
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
    
    private func readJpegTableMatrix() -> [[Int]] {
        var matrix = Array(repeating: Array(repeating: 0, count: 256), count: 256)
        
        for i in 0..<256 {
            for j in 0..<256 {
                if let numberToWrite = getJpegNumber() {
                    matrix[i][j] = numberToWrite
                }
            }
        }
        
        return matrix
    }
    
    private func getJpegNumber() -> Int? {
        let bitsToRead = getBitsToRead()
        
        guard bitsToRead != 0 else {
            return 0
        }
        
        let maxValueForBits = pow(2, Double(bitsToRead)) - 1
        
        if let value = bitReader.ReadNBits(numberOfBits: bitsToRead) {
            if Double(value) < (maxValueForBits / 2) {
                return  (Int(maxValueForBits) - Int(value)) * (-1)
            }
            return Int(value)
        } else {
            return nil
        }
    }
    
    private func getBitsToRead() -> Int {
        var bitsToRead = 0
        
        while bitReader.ReadBit() == 1 {
            bitsToRead += 1
        }
        
        return bitsToRead
    }
    
    private func getCodes(from errors: [[Int]], with options: EncodingOptions) -> [[UInt8]] {
        let predictor = ValuePredictor(predictorType: options.predictorType)
        var matrices = NearLosslessMatrices(width: errors[0].count, height: errors[0].count, isDecoding: true)
        matrices.quantizedErrors = errors
        matrices.predictMatrices(with: predictor, acceptedError: options.acceptedError)
        
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
