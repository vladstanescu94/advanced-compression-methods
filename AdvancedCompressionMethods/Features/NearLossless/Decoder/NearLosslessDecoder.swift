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
    var decodingMatrices: NearLosslessMatrices? = nil
    
    init(bitReader: BitReader, bitWriter: BitWriter) {
        self.bitReader = bitReader
        self.bitWriter = bitWriter
    }
    
    public func decode() {
        copyHeader()
        if let options = getOptions() {
            let errorMatrix = readErrorMatrix(saveMode: options.saveMode)
            decodingMatrices = getCodes(from: errorMatrix, with: options)
            
            if let matrices = decodingMatrices {
                writePixelData(from: matrices.decoded)
            }
            
            if let service = bitWriter.fileService as? FileService {
                if let decodedURL =  service.fileURL {
                    self.decodedFileURL = decodedURL
                }
            }
        }
    }
    
    private func copyHeader() {
        for _ in 0..<BmpConstants.headerSize.rawValue {
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
    
    // MARK: - Matrix read
    
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
        let matrixSize = 256
        var matrix = Array(repeating: Array(repeating: 0, count: matrixSize), count: matrixSize)
        
        for i in 0..<matrixSize {
            for j in 0..<matrixSize {
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
        let matrixSize = 256
        var matrix = Array(repeating: Array(repeating: 0, count: matrixSize), count: matrixSize)
        
        for i in 0..<matrixSize {
            for j in 0..<matrixSize {
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
    
    // MARK: - Get Pixel Values
    
    private func getCodes(from errors: [[Int]], with options: EncodingOptions) -> NearLosslessMatrices {
        let predictor = ValuePredictor(predictorType: options.predictorType)
        var matrices = NearLosslessMatrices(width: errors[0].count, height: errors[0].count, isDecoding: true)
        matrices.quantizedErrors = errors
        matrices.predictMatrices(with: predictor, acceptedError: options.acceptedError)
        
        return matrices
    }
    
    private func writePixelData(from matrix: [[UInt8]]) {
        for i in stride(from: matrix[0].count - 1, through: 0, by: -1){
            for j in 0..<matrix[0].count {
                bitWriter.writeNBits(numberOfBits: 8, value: UInt32(matrix[j][i]))
            }
        }
    }
}
