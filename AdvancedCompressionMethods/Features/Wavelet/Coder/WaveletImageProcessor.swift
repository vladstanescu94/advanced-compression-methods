//
//  WaveletImageProcessor.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import Foundation

final class WaveletImageProcessor {
    let analyzer =  WaveletAnalyzer(lowCoefficients: AnalysisCoefficients.low,
                                    highCoefficients: AnalysisCoefficients.high)
    let synthesizer = WaveletSynthesizer(lowCoefficients: SynthesisCoefficients.low,
                                         highCoefficients: SynthesisCoefficients.high)
    
    var pixelData: [[Double]] = []
    
    public func loadData(pixelData: [[UInt8]]) {
        self.pixelData = pixelData.map { $0.map { Double($0) } }
    }
    
    // MARK: - Horizontal Analysis
    
    public func analyseHorizontally(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getHorizontalLine(number: i, length: length)
            let analysedLine = analyzer.analyse(line: line)
            replaceWithAnalysedLine(analysedLine: analysedLine, index: i)
        }
    }
    
    private func getHorizontalLine(number: Int, length: Int) -> [Double] {
        var line = [Double]()
        
        for i in 0..<length {
            line.append(pixelData[i][number])
        }
        
        return line
    }
    
    private func replaceWithAnalysedLine(analysedLine: WaveletAnalysis, index: Int) {
        for i in 0..<analysedLine.rearrangedLow.count {
            pixelData[i][index] = analysedLine.rearrangedLow[i]
        }
        
        for i in 0..<analysedLine.rearrangedHigh.count {
            pixelData[i + analysedLine.rearrangedLow.count][index] = analysedLine.rearrangedHigh[i]
        }
    }
    
    // MARK: - Vertical Analysis
    
    public func analyseVertically(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getVerticalLine(number: i, length: length)
            let analysedLine = analyzer.analyse(line: line)
            replaceWithVerticalAnalysedLine(analysedLine: analysedLine, index: i)
        }
    }
    
    private func getVerticalLine(number: Int, length: Int) -> [Double] {
        var line = [Double]()
        
        for i in 0..<length {
            line.append(pixelData[number][i])
        }
        
        return line
    }
    
    private func replaceWithVerticalAnalysedLine(analysedLine: WaveletAnalysis, index: Int) {
        for i in 0..<analysedLine.rearrangedLow.count {
            pixelData[index][i] = analysedLine.rearrangedLow[i]
        }
        
        for i in 0..<analysedLine.rearrangedHigh.count {
            pixelData[index][i + analysedLine.rearrangedLow.count] = analysedLine.rearrangedHigh[i]
        }
    }
    
    // MARK: - Horizontal Synthesis
    
    public func synthesisHorizontally(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getHorizontalLine(number: i, length: length)
            let synthesisFormat = formatForSynthesis(line: line)
            let synthesisedLine = synthesizer.synthesize(line: synthesisFormat)
            replaceWithSynthesizedLine(synthesisedLine: synthesisedLine, index: i)
        }
    }
    
    private func formatForSynthesis(line: [Double]) -> WaveletAnalysis {
        return WaveletAnalysis(low: Array(line[0..<(line.count / 2)]),
                               high: Array(line[(line.count / 2)..<line.count]))
    }
    
    private func replaceWithSynthesizedLine(synthesisedLine: [Double], index: Int) {
        for i in 0..<synthesisedLine.count {
            pixelData[i][index] = synthesisedLine[i]
        }
    }
    
    // MARK: - Vertical Synthesis
    
    public func synthesisVertically(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getVerticalLine(number: i, length: length)
            let synthesisFormat = formatForSynthesis(line: line)
            let synthesisedLine = synthesizer.synthesize(line: synthesisFormat)
            replaceWithVerticallySynthesizedLine(synthesisedLine: synthesisedLine, index: i)
        }
    }
    
    private func replaceWithVerticallySynthesizedLine(synthesisedLine: [Double], index: Int) {
        for i in 0..<synthesisedLine.count {
            pixelData[index][i] = synthesisedLine[i]
        }
    }
}
