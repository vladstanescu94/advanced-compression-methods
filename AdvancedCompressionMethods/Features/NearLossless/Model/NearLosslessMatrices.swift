//
//  NearLosslessMatrices.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation
import Cocoa

struct NearLosslessMatrices {
    var width: Int
    var height: Int
    
    var isDecoding: Bool = false
    
    var pixelValues = [[UInt8]]()
    var predictions = [[UInt8]]()
    var errors = [[Int]]()
    var quantizedErrors = [[Int]]()
    var dequantizedErrors = [[Int]]()
    var decoded = [[UInt8]]()
    
    init(width: Int, height: Int, isDecoding: Bool = false) {
        self.width = width
        self.height = height
        self.isDecoding = isDecoding
        initMatrices()
    }
    
    init(image: NSBitmapImageRep) {
        self.init(width: image.pixelsWide, height: image.pixelsHigh)
        AddImageCodes(image: image)
        
    }
    
    private mutating func initMatrices() {
        pixelValues = Array(repeating: Array(repeating: 0, count: height), count: width)
        predictions = Array(repeating: Array(repeating: 0, count: height), count: width)
        errors = Array(repeating: Array(repeating: 0, count: height), count: width)
        quantizedErrors = Array(repeating: Array(repeating: 0, count: height), count: width)
        dequantizedErrors = Array(repeating: Array(repeating: 0, count: height), count: width)
        decoded = Array(repeating: Array(repeating: 0, count: height), count: width)
    }
    
    private mutating func AddImageCodes(image: NSBitmapImageRep) {
        for i in 0..<width {
            for j in 0..<height {
                if let pixelValue = image.colorAt(x: i, y: j)?.redComponent {
                    pixelValues[i][j] = UInt8(pixelValue * 255)
                }
            }
        }
    }
    
    public mutating func predictMatrices(with predictor: ValuePredictor, acceptedError: Int) {
        predictFirstPixel(acceptedError: acceptedError)
        predictFirstColumn(acceptedError: acceptedError, predictor: predictor)
        predictFirstRow(acceptedError: acceptedError, predictor: predictor)
        
        for i in 1..<self.width {
            for j in 1..<self.height {
                let a = self.decoded[i-1][j]
                let b = self.decoded[i][j-1]
                let c = self.decoded[i-1][j-1]
                
                let prediction = predictor.predict(values: [a, b, c])
                
                setPrediction(acceptedError: acceptedError, row: i, column: j, prediction: prediction)
            }
        }
    }
    
    private mutating func predictFirstPixel(acceptedError: Int) {
        setPrediction(acceptedError: acceptedError, row: 0, column: 0, prediction: 128)
    }
    
    private mutating func predictFirstColumn(acceptedError: Int, predictor: ValuePredictor) {
        let b: UInt8 = 0
        let c: UInt8 = 0
        
        for i in 1..<self.width {
            let a = self.decoded[i-1][0]
            let prediction = predictor.predict(values: [a, b, c])
            setPrediction(acceptedError: acceptedError, row: i, column: 0, prediction: prediction)
        }
    }
    
    private mutating func predictFirstRow(acceptedError: Int, predictor: ValuePredictor) {
        let a: UInt8 = 0
        let c: UInt8 = 0
        
        for j in 1..<self.height {
            let b = self.decoded[0][j-1]
            let prediction = predictor.predict(values: [a, b, c])
            setPrediction(acceptedError: acceptedError, row: 0, column: j, prediction: prediction)
        }
    }
    
    private mutating func setPrediction(acceptedError: Int, row: Int, column: Int, prediction: UInt8) {
        let k = acceptedError
        let error: Int = Int(self.pixelValues[row][column]) - Int(prediction)
        let quantizedError = isDecoding ? self.quantizedErrors[row][column]  : quantize(error: error, k: k)
        let dequantizedError = dequantize(error: quantizedError, k: k)
        let decoded = (dequantizedError + Int(prediction)).toByte()
        
        self.predictions[row][column] = prediction
        self.errors[row][column] = error
        self.quantizedErrors[row][column] = quantizedError
        self.dequantizedErrors[row][column] = dequantizedError
        self.decoded[row][column] = decoded
    }
}
