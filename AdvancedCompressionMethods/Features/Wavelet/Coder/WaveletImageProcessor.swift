import Foundation

enum AnalyzeMode {
    case horizontal
    case vertical
}

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
            let line = getLine(number: i, length: length, mode: .horizontal)
            let analysedLine = analyzer.analyse(line: line)
            replaceWithAnalysedLine(analysedLine: analysedLine, index: i, mode: .horizontal)
        }
    }
    
    private func getLine(number: Int, length: Int, mode: AnalyzeMode) -> [Double] {
        var line = [Double]()
        
        switch mode {
        case .horizontal:
            for i in 0..<length {
                line.append(pixelData[i][number])
            }
        case .vertical:
            for i in 0..<length {
                line.append(pixelData[number][i])
            }
        }
        
        return line
    }
    
    private func replaceWithAnalysedLine(analysedLine: WaveletAnalysis, index: Int, mode: AnalyzeMode) {
        switch mode {
        case .horizontal:
            for i in 0..<analysedLine.rearrangedLow.count {
                pixelData[i][index] = analysedLine.rearrangedLow[i]
            }
            
            for i in 0..<analysedLine.rearrangedHigh.count {
                pixelData[i + analysedLine.rearrangedLow.count][index] = analysedLine.rearrangedHigh[i]
            }
        case .vertical:
            for i in 0..<analysedLine.rearrangedLow.count {
                pixelData[index][i] = analysedLine.rearrangedLow[i]
            }
            
            for i in 0..<analysedLine.rearrangedHigh.count {
                pixelData[index][i + analysedLine.rearrangedLow.count] = analysedLine.rearrangedHigh[i]
            }
        }
    }
    
    // MARK: - Vertical Analysis
    
    public func analyseVertically(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getLine(number: i, length: length, mode: .vertical)
            let analysedLine = analyzer.analyse(line: line)
            replaceWithAnalysedLine(analysedLine: analysedLine, index: i, mode: .vertical)
        }
    }
    
    // MARK: - Horizontal Synthesis
    
    public func synthesisHorizontally(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getLine(number: i, length: length, mode: .horizontal)
            let synthesisFormat = formatForSynthesis(line: line)
            let synthesisedLine = synthesizer.synthesize(line: synthesisFormat)
            replaceWithSynthesizedLine(synthesisedLine: synthesisedLine, index: i, mode: .horizontal)
        }
    }
    
    private func formatForSynthesis(line: [Double]) -> WaveletAnalysis {
        return WaveletAnalysis(low: Array(line[0..<(line.count / 2)]),
                               high: Array(line[(line.count / 2)..<line.count]))
    }
    
    private func replaceWithSynthesizedLine(synthesisedLine: [Double], index: Int, mode: AnalyzeMode) {
        switch mode {
        case .horizontal:
            for i in 0..<synthesisedLine.count {
                pixelData[i][index] = synthesisedLine[i]
            }
        case .vertical:
            for i in 0..<synthesisedLine.count {
                pixelData[index][i] = synthesisedLine[i]
            }
        }
    }
    
    // MARK: - Vertical Synthesis
    
    public func synthesisVertically(level: Int) {
        let length = pixelData[0].count / level
        
        for i in 0..<length {
            let line = getLine(number: i, length: length, mode: .vertical)
            let synthesisFormat = formatForSynthesis(line: line)
            let synthesisedLine = synthesizer.synthesize(line: synthesisFormat)
            replaceWithSynthesizedLine(synthesisedLine: synthesisedLine, index: i, mode: .vertical)
        }
    }
}
