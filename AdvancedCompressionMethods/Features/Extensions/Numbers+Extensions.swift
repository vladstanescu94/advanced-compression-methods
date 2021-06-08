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

extension Double {
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
