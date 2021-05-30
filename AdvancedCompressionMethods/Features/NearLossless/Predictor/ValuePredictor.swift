//
//  ValuePredictor.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation

struct ValuePredictor {
    let predictorType: PredictorType
    
    var values: [UInt8]
    var a: UInt8 {
        values[0]
    }
    var b: UInt8 {
        values[1]
    }
    var c: UInt8 {
        values[2]
    }
    
    init(predictorType: PredictorType, values: [UInt8]) {
        self.predictorType = predictorType
        self.values = values
    }
    
    public func predict() -> UInt8 {
        switch predictorType {
        case .predictor0:
            return 128
        case .predictor1:
            return a
        case .predictor2:
            return b
        case .predictor3:
            return c
        case .predictor4:
            return a + b - c
        case .predictor5:
            return a + (b - c) / 2
        case .predictor6:
            return b + (a - c) / 2
        case .predictor7:
            return (a + b) / 2
        case .predictor8:
            return jpegLS()
        }
    }
    
    private func jpegLS() -> UInt8 {
        if c >= max(a, b) {
            return min(a, b)
        }
        
        if c <= min(a, b) {
            return max(a, b)
        }
        
        return a + b - c
    }
}
