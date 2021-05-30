//
//  Int+toByte.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation

extension Int {
    func toByte() -> UInt8 {
        if self < 0 {
            return 0
        }

        if self > 255 {
            return 255
        }

        return UInt8(self)
    }
}
