//
//  WaveletAnalyzer.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import Foundation

struct WaveletAnalyzer {
    let lowCoefficients: [Double]
    let highCoefficients: [Double]
    
    func analyse(line: [Double]) -> WaveletAnalysis {
        var analisysData = WaveletAnalysis()
        let formattedLine = mirrorLineValues(line: line)
        
        for i in 0..<line.count {
            var low = 0.0
            var high = 0.0
            
            for j in 0..<9 {
                low += formattedLine[i + j] * lowCoefficients[j]
                high += formattedLine[i + j] * highCoefficients[j]
            }
            
            if i % 2 == 0 {
                low = round(low)
                analisysData.rearrangedLow.append(low)
            } else {
                high = round(high)
                analisysData.rearrangedHigh.append(high)
            }
        }
        
        return analisysData
    }
}
