import Foundation

enum UpSampleMode {
    case low
    case high
}

struct WaveletSynthesizer {
    let lowCoefficients: [Double]
    let highCoefficients: [Double]
    
    func synthesize(line: WaveletAnalysis) -> [Double] {
        var reconstructedValues = [Double]()
        
        let low = upSampleValues(values: line.rearrangedLow, mode: .low)
        let high = upSampleValues(values: line.rearrangedHigh, mode: .high)
        
        let mirrorLow = mirrorLineValues(line: low)
        let mirrorHigh = mirrorLineValues(line: high)
        
        for i in 0..<(line.rearrangedLow.count + line.rearrangedHigh.count) {
            var lowValue = 0.0
            var highValue = 0.0
            
            for j in 0..<9 {
                lowValue += mirrorLow[i + j] * lowCoefficients[j]
                highValue += mirrorHigh[i + j] * highCoefficients[j]
            }
            
            reconstructedValues.append(lowValue + highValue)
        }
        
        return reconstructedValues
    }
    
    private func upSampleValues(values: [Double], mode: UpSampleMode) -> [Double] {
        var upSampledValues = [Double]()
        switch mode {
        case .low:
            for value in values {
                upSampledValues.append(value)
                upSampledValues.append(0)
            }
        case .high:
            for value in values {
                upSampledValues.append(0)
                upSampledValues.append(value)
            }
        }
        return upSampledValues
    }
}
