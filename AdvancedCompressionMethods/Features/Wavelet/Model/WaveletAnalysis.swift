//
//  WaveletAnalysis.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import Foundation

struct WaveletAnalysis {
    var rearrangedLow: [Double]
    var rearrangedHigh: [Double]
    
    init() {
        rearrangedLow = [Double]()
        rearrangedHigh = [Double]()
    }
    
    init(low: [Double], high: [Double]) {
        rearrangedLow = low
        rearrangedHigh = high
    }
}
