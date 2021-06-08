import SwiftUI

struct NearLosslessControlsView: View {
    @ObservedObject var viewModel: NearLosslessViewModel
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }

    var body: some View {
        HStack(spacing: 100) {
            VStack {
                Picker(selection: $viewModel.selectedPredictorType, label: Text("Predictor:"), content: {
                    Text("128").tag(PredictorType.predictor0)
                    Text("A").tag(PredictorType.predictor1)
                    Text("B").tag(PredictorType.predictor2)
                    Text("C").tag(PredictorType.predictor3)
                    Text("A+B-C").tag(PredictorType.predictor4)
                    Text("A+(B-C)/2").tag(PredictorType.predictor5)
                    Text("B+(A-C)/2").tag(PredictorType.predictor6)
                    Text("(A+B)/2").tag(PredictorType.predictor7)
                    Text("jpegLS").tag(PredictorType.predictor8)
                })
                .frame(maxWidth: 300)
                Picker(selection: $viewModel.selectedSaveMode, label: Text("Save Mode:"), content: {
                    Text("9 bits").tag(ImageSaveMode.fix)
                    Text("JPEG Table").tag(ImageSaveMode.jpegTable)
                    Text("Arithmetic").tag(ImageSaveMode.arithmetic)
                })
                .frame(maxWidth: 300)
                Picker(selection: $viewModel.acceptedError, label: Text("Accepted Error:"), content: {
                    ForEach(0...10, id: \.self) {
                        Text("\($0)")
                    }
                })
                .frame(maxWidth: 300)
                Slider(value: $viewModel.errorScale, in: 0...1){
                    Text("Error Scale \(viewModel.errorScale, specifier: "%.2f")")
                }
                .frame(maxWidth: 300)
            }
            VStack(alignment: .trailing) {
                Picker(selection: $viewModel.selectedHistogramSource, label: Text("Histogram Input:"), content: {
                    Text("Original").tag(0)
                    Text("Error Prediction").tag(1)
                    Text("Error Prediction Quantized").tag(2)
                    Text("Decoded").tag(3)
                })
                .frame(maxWidth: 300)
                Slider(value: $viewModel.histogramScale, in: 0...1){
                    Text("Histogram Scale \(viewModel.histogramScale, specifier: "%.2f")")
                }
                .frame(maxWidth: 300)
                
                Button {
                    viewModel.histogramData = nil
                    viewModel.generateHistogramData()
                    
                } label: {
                    Text("Show Histogram")
                }
                
                Group {
                    VStack(alignment: .leading) {
                        Button {
                            viewModel.computeMinMaxError()
                        } label: {
                            Text("Compute Error")
                        }
                        
                        if let min = viewModel.minimumError,
                           let max = viewModel.maximumError {
                            Text("Minimum error \(min)")
                            Text("Maximum error \(max)")
                        }
                        
                    }
                }
            }
            
            if let histData = viewModel.histogramData {
                HistogramView(entries: histData)
            }

        }
        .padding()
    }
}
