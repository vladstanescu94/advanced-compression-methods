//
//  NearLosslessMatrices.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation
import Cocoa

struct NearLosslessMatrices {
    var width: Int
    var height: Int
    
    var codes = [[UInt8]]()
    var predictions = [[UInt8]]()
    var errors = [[Int]]()
    var quantizedErrors = [[Int]]()
    var dequantizedErrors = [[Int]]()
    var decoded = [[UInt8]]()
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    init(image: NSBitmapImageRep) {
        self.init(width: image.pixelsWide, height: image.pixelsHigh)
        
    }
    
    private mutating func AddImageCodes(image: NSBitmapImageRep) {
        for i in 0..<width {
            for j in 0..<height {
                if let pixelValue = image.colorAt(x: i, y: j)?.redComponent {
                    codes[i][j] = UInt8(pixelValue)
                }
            }
        }
    }
}
