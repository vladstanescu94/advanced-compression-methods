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
