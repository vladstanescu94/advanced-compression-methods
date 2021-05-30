//
//  Quantize.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation

func quantize(error: Int, k: Int) -> Int {
    return (error + k) / (2 * k + 1)
}

func dequantize(error: Int, k: Int) -> Int {
    return error * (2 * k + 1)
}
