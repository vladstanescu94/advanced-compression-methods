import Foundation

class BitWriter {
    // MARK: - Properties
    public let fileService: FileServiceProtocol
    
    private var buffer: UInt8 = 0
    private var bitsWritten: Int = 0
    
    public init(fileService: FileServiceProtocol) {
        self.fileService = fileService
        self.fileService.openFile()
    }
    
    // MARK: - Write Methods
    public func writeNBits(numberOfBits: Int, value: UInt32) {
        guard numberOfBits > 0,
              numberOfBits <= 32 else { return }
        
        for i in 1...numberOfBits {
            let bitToWrite = CFBit((value >> (numberOfBits - i)) & 1)
            writeBit(bit: bitToWrite)
        }
    }
    
    public func writeBit(bit: CFBit) {
        buffer <<= 1
        buffer += UInt8(bit)
        bitsWritten += 1
        
        if bitsWritten % 8 == 0 {
            writeBufferToFile()
        }
    }
    
    private func writeBufferToFile() {
        let data = Data(bytes: &buffer, count: 1)
        
        do {
            try self.fileService.writeByteToFile(data: data)
            resetBuffer()
        } catch {
            print("Could not write to file \(error)")
        }
    }
    
    private func resetBuffer() {
        buffer = 0
    }
    
    // MARK: - Cleanup
    
    deinit {
        close()
    }
    
    public func close() {
        for _ in 1..<8 {
            writeBit(bit: 1)
        }
        self.fileService.closeFile()
    }
}
