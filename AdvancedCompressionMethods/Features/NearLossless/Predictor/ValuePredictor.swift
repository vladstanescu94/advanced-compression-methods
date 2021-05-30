//
//  ValuePredictor.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation

struct ValuePredictor {
    let predictorType: PredictorType
    
    
    init(predictorType: PredictorType) {
        self.predictorType = predictorType
    }
    
    public func predict(values: [UInt8]) -> UInt8 {
        let a = values[0]
        let b = values[1]
        let c = values[2]
        
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
            let result = Int(a) + Int(b) - Int(c)
            return result.toByte()
        case .predictor5:
            let result = Int(a) + (Int(b) - Int(c)) / 2
            return result.toByte()
        case .predictor6:
            let result = Int(b) + (Int(a) - Int(c)) / 2
            return result.toByte()
        case .predictor7:
            let result = (Int(a) + Int(b)) / 2
            return result.toByte()
        case .predictor8:
            return jpegLS(a: a, b: b, c: c)
        }
    }
    
    private func jpegLS(a: UInt8, b: UInt8, c:UInt8) -> UInt8 {
        if c >= max(a, b) {
            return min(a, b)
        }
        
        if c <= min(a, b) {
            return max(a, b)
        }
        let result =  Int(a) + Int(b) - Int(c)
        return result.toByte()
    }
}
