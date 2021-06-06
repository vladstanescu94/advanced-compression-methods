//
//  MirrorLineValues.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 06.06.2021.
//

import Foundation

func mirrorLineValues<T> (line: [T]) -> [T] {
    var newLine = [T]()
    
    for i in stride(from: 4, to: 0, by: -1) {
        newLine.append(line[i])
    }
    
    newLine.append(contentsOf: line)
    
    let indexOfLastElement = line.count - 1
    
    for i in 0..<4 {
        newLine.append(line[indexOfLastElement - 1 - i])
    }
    
    return newLine
}
