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
    @Published var highlightXValue: Double = 512
    @Published var highlightYValue: Double = 512
    @Published var offsetValue: Double = 128.0
    @Published var scaleValue: Double = 1.0
    @Published var minError: Double? = nil
    @Published var maxError: Double? = nil
    @Published var numberOfLevels: Int = 1
    @Published var waveletImage: NSImage? = nil
    
    let coder = WaveletImageProcessor()
    
    var originalImage: NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    func setWaveletImage() {
        if let origURL = originalImageURL {
            waveletImage = NSImage(contentsOf: origURL)
        } else {
            waveletImage = nil
        }
    }
    
    func decodeWaveletFile() {
        // TODO: - Implement this
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
    
    public func loadCoder() {
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
                
                if i >= Int(highlightXValue) || j >= Int(highlightYValue) {
                    pixel = (Double(pixel) * 1.0 + offsetValue).toByte()
                }
                newPixelData.append(pixel)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let somePointer = UnsafeMutablePointer(mutating: newPixelData)
        let context = CGContext(data: somePointer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
        waveletImage = context!.makeImage().flatMap { NSImage(cgImage: $0, size: NSSize(width: width, height: height)) }
    }
    
    func doubleHighlightXValue() {
        let newValue = highlightXValue * 2
        highlightXValue = newValue > 512 ? highlightXValue : newValue
    }
    
    func doubleHighlightYValue() {
        let newValue = highlightYValue * 2
        highlightYValue = newValue > 512 ? highlightYValue : newValue
    }
    
    func halveHighlightXValue() {
        let newValue = highlightXValue / 2
        highlightXValue = newValue < 0 ? highlightXValue : newValue
    }
    
    func halveHighlightYValue() {
        let newValue = highlightYValue / 2
        highlightYValue = newValue < 0 ? highlightYValue : newValue
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
