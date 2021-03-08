import Foundation

class BitReader {
    // MARK: - Properties
    public let fileService: FileServiceProtocol
    
    private var buffer: UInt8 = 0
    private var bitsRead: Int = 0
    private var totalBitsRead: Int = 0
    
    public init(fileService: FileServiceProtocol) {
        self.fileService = fileService
        self.fileService.openFile()
    }
    
    // MARK: - Read Methods
    public func ReadNBits(numberOfBits: Int) -> UInt32? {
        guard numberOfBits > 0,
              numberOfBits <= 32 else { return nil }
        
        var result: UInt32 = 0
        
        for _ in 0..<numberOfBits {
            result <<= 1
            result += ReadBit()
        }
        
        return result
    }
    
    public func ReadBit() -> CFBit {
        if isBufferEmpty() {
            do {
                if let data = try self.fileService.readByteFromFile(),
                   data.isEmpty == false {
                    buffer = UInt8(data[0])
                    bitsRead = 8
                    totalBitsRead += bitsRead
                }
            } catch {
                print("Could not read byte from file")
            }
        }
        
        bitsRead -= 1
        let bit: CFBit = CFBit((buffer >> bitsRead) & 0x01)
        return bit
    }
    
    public func isBufferEmpty() -> Bool {
        return bitsRead == 0
    }
    
    private func resetBuffer() {
        buffer = 0
    }
    
    // MARK: - Cleanup
    
    deinit {
        close()
    }
    
    public func close() {
        self.fileService.closeFile()
    }
}
