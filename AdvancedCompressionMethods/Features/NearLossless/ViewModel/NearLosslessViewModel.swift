//
//  NearLosslessViewModel.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 29.05.2021.
//

import Foundation
import Cocoa
import Charts

final class NearLosslessViewModel: ObservableObject {
    @Published var originalImageURL: URL? = nil
    @Published var originalImagePixels: [[UInt8]]? = nil
    @Published var encodedFileURL: URL? = nil
    @Published var decodedImageURL: URL? = nil
    @Published var selectedPredictorType: PredictorType = .predictor0
    @Published var selectedSaveMode: ImageSaveMode = .fix
    @Published var acceptedError: Int = 0
    @Published var decodingMatrices: NearLosslessMatrices? = nil
    @Published var errorScale: Double = 0.10
    @Published var errorMatrixImage: NSImage? = nil
    @Published var selectedHistogramSource: Int = 0
    @Published var histogramScale: Double = 1.0
    @Published var histogramData: [BarChartDataEntry]? = nil
    @Published var minimumError: Int? = nil
    @Published var maximumError: Int? = nil
    
    private var freqDict: [Int:Int] = [:]
    
    var originalImage: NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    var decodedImage: NSImage? {
        guard let imageURL = decodedImageURL else { return nil}
        
        return NSImage(contentsOf: imageURL)
    }
    
    func getOriginalImageData() -> NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    // MARK: - Encode
    
    func encode() {
        guard let imageToEncodeURL = originalImageURL else { return }
        
        let bitReader = BitReader(fileService:
                                    PopupFileService(
                                        fileURL: imageToEncodeURL,
                                        fileMode: .read))
        
        let encodedFileName = generateFileName()
        
        let bitWriter = BitWriter(fileService:
                                    FileService(
                                        fileName: encodedFileName,
                                        fileMode: .write))
        
        let options = EncodingOptions(predictorType: selectedPredictorType, saveMode: selectedSaveMode, acceptedError: acceptedError)
        let encoder = NearLosslessEncoder(bitReader: bitReader, bitWriter: bitWriter, encodingOptions: options)
        encoder.encode()
        originalImagePixels = encoder.originalImagePixelData
    }
    
    private func generateFileName() -> String {
        let predictorType = selectedPredictorType.rawValue
        let fileSaveMode: String
        
        switch selectedSaveMode {
        case .fix:
            fileSaveMode = "F"
        case .jpegTable:
            fileSaveMode = "T"
        case .arithmetic:
            fileSaveMode = "A"
        }
        
        let fileName = originalImageURL!.lastPathComponent
        let encodedFileName = "\(fileName).p\(predictorType)k\(acceptedError)\(fileSaveMode).prd"
        return encodedFileName
    }
    
    // MARK: - Decode
    
    func decode() {
        guard let fileToDecode = encodedFileURL else { return }
        
        let decodedFileName = fileToDecode.lastPathComponent
        
        let bitReader = BitReader(fileService:
                                    PopupFileService(
                                        fileURL: fileToDecode,
                                        fileMode: .read))
        let bitWriter = BitWriter(fileService:
                                    FileService(
                                        fileName: "\(decodedFileName).bmp",
                                        fileMode: .write))
        
        let decoder = NearLosslessDecoder(bitReader: bitReader, bitWriter: bitWriter)
        decoder.decode()
        decodedImageURL = decoder.decodedFileURL
        decodingMatrices = decoder.decodingMatrices
    }
    
    func generateErrorMatrixImage() {
        guard let matrices = decodingMatrices else { return }
        var pixelData: [UInt8] = [UInt8]()
        let width = 256
        let height = 256
        
        for i in 0..<width{
            for j in 0..<height {
                let pixel = abs(128.0 + Double(matrices.errors[j][i]) * errorScale).toByte()
                pixelData.append(pixel)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: pixelData.count)
        uint8Pointer.initialize(from: &pixelData, count: pixelData.count)
        let context = CGContext(data: uint8Pointer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
    
        errorMatrixImage = context!.makeImage().flatMap { NSImage(cgImage: $0, size: NSSize(width: width, height: height)) }
    }
    
    func generateHistogramData() {
        generateFrequences()
        histogramData = nil
        
        let indexes = Array(-255..<256)
        
        var points: [BarChartDataEntry] = []

        for i in indexes.indices {
            let value = Double(freqDict[indexes[i]]!) * histogramScale
            points.append(BarChartDataEntry(x: Double(indexes[i]), y: value))
        }
    
        histogramData = points
    }
    
    private func generateFrequences() {
        guard let originalPixels = originalImagePixels,
              let decodedMatrices = decodingMatrices else { return }
        
        switch selectedHistogramSource {
        case 0:
            getFrequency(from: originalPixels)
        case 1:
            getFrequency(from: decodedMatrices.dequantizedErrors)
        case 2:
            getFrequency(from: decodedMatrices.quantizedErrors)
        case 3:
            getFrequency(from: decodedMatrices.decoded)
        default:
            getFrequency(from: originalPixels)
        }
    }
    
    private func getFrequency<T: BinaryInteger>(from matrix: [[T]]) {
        for i in -255..<256 {
            freqDict[i] = 0
        }
        
        for i in 0..<256 {
            for j in 0..<256 {
                let value = matrix[i][j]
                freqDict[Int(value)]! += 1
            }
        }
    }
    
    func computeMinMaxError() {
        guard let original = originalImagePixels,
              let decoded = decodingMatrices?.decoded else { return }
        
        var errors:[Int]  = []
        
        for i in 0..<256 {
            for j in 0..<256 {
                let error = Int(original[i][j]) - Int(decoded[i][j])
                errors.append(error)
            }
        }
        
        minimumError = errors.min()
        maximumError = errors.max()
    }
    
}
