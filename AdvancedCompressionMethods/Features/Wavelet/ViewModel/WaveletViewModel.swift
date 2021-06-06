//
//  WaveletViewModel.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import Foundation
import Cocoa
import Combine

final class WaveletViewModel: ObservableObject {
    @Published var originalImageURL: URL? = nil
    @Published var waveletImageURL: URL? = nil
    @Published var originalImagePixelValues: [[UInt8]]? = nil
//    @Published var highlightXString: String = "512"
//    @Published var highlightYString: String = "512"
//    @Published var offsetString: String = "128"
//    @Published var scaleValue: Double = 1.0
    @Published var minError: Double? = nil
    @Published var maxError: Double? = nil
    @Published var numberOfLevels: Int = 1
    @Published var waveletImage: NSImage? = nil
    
    let coder = WaveletImageProcessor()
    
    var originalImage: NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
//    var highlightXValue: Int {
//        let filtered = highlightXString.filter { "0123456789".contains($0) }
//
//        if let value = Int(filtered) {
//            if value < 0 {
//                return 0
//            }
//            if value > 512 {
//                return 512
//            }
//
//            return value
//        }
//
//        return 0
//    }
//
//    var highlightYValue: Int {
//        let filtered = highlightYString.filter { "0123456789".contains($0) }
//
//        if let value = Int(filtered) {
//            if value < 0 {
//                return 0
//            }
//            if value > 512 {
//                return 512
//            }
//
//            return value
//        }
//
//        return 0
//    }
//
//    var offsetValue: Int {
//        let filtered = offsetString.filter { "0123456789".contains($0) }
//
//        if let value = Int(filtered) {
//            if value < 0 {
//                return 0
//            }
//            if value > 128 {
//                return 128
//            }
//
//            return value
//        }
//
//        return 0
//    }
    
    func setWaveletImage() {
        if let origURL = originalImageURL {
            waveletImage = NSImage(contentsOf: origURL)
        } else {
            waveletImage = nil
        }
    }
    
    func decodeWaveletFile() {
        
    }
    
    public func getPixelData(from image: NSImage) {
        guard let imageRep = image.representations.first as? NSBitmapImageRep else { return }
        
        let width = imageRep.pixelsWide
        let height = imageRep.pixelsHigh
        
        var pixels: [[UInt8]] = Array(repeating: Array(repeating: 0, count: height), count: width)
        
        for i in 0..<width {
            for j in 0..<height {
                if let pixelValue = imageRep.colorAt(x: i, y: j)?.redComponent {
                    pixels[i][j] = UInt8(pixelValue * 255)
                }
            }
        }
        
        originalImagePixelValues = pixels
    }
    
    public func encode() {
        guard let pixelData = originalImagePixelValues else { return }
        coder.loadData(pixelData: pixelData)
    }
    
    public func updateWaveletImage() {
        let pixelData = coder.pixelData
        let width = pixelData[0].count
        let height = pixelData[0].count
        
        var newPixelData =  [UInt8]()
        
        for i in 0..<width {
            for j in 0..<height {
                var pixel = abs(round(pixelData[j][i])).toByte()
                
//                if i >= highlightXValue || j >= highlightYValue {
//                    pixel = (Double(pixel) * scaleValue + Double(offsetValue)).toByte()
//                }
                newPixelData.append(pixel)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let somePointer = UnsafeMutablePointer(mutating: newPixelData)
        let context = CGContext(data: somePointer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
        waveletImage = context!.makeImage().flatMap { NSImage(cgImage: $0, size: NSSize(width: width, height: height)) }
    }
    
    func doubleHighlightValue(value: String) {
        var value = value
        if let intValue = Int(value) {
            let newValue = intValue * 2
            
            value = newValue > 512 ? value : String(newValue)
        }
    }
    
    func halveHighlightValue(value: String) {
        var value = value
        if let intValue = Int(value) {
            let newValue = intValue / 2
            
            value = newValue < 0 ? value : String(newValue)
        }
    }
    
    func testErrors() {
        guard let originalPixels = originalImagePixelValues else { return }
        var errors = [Double]()
        
        for i in 0..<originalPixels[0].count {
            for j in 0..<originalPixels[0].count {
                let error = coder.pixelData[i][j] - Double(originalPixels[i][j])
                errors.append(error)
            }
        }
        
        minError = errors.min()
        maxError = errors.max()
    }
}
