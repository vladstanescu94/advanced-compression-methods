import Foundation

struct BitWriter {
    public let fileService: FileServiceProtocol
    
    private var buffer: UInt8 = 0
    private var bitsWritten: Int = 0
    
    public init(fileService: FileServiceProtocol) {
        self.fileService = fileService
    }
    
    public mutating func writeNBits(numberOfBits: Int, value: UInt32) {
        guard numberOfBits > 0,
              numberOfBits <= 32 else { return }
        // TODO
    }
    
    public mutating func writeBit(bit: CFBit) {
        buffer <<= 1
        buffer += UInt8(bit)
        bitsWritten += 1
        
        if isBufferFull() {
            writeBufferToFile()
        }
    }
    
    public func isBufferFull() -> Bool {
        return bitsWritten == 8
    }
    
    private mutating func writeBufferToFile() {
        guard fileService.fileMode == .write else { return }
        
        self.fileService.fileHandle?.seekToEndOfFile()
        self.fileService.fileHandle?.write(Data(bytes: &buffer, count: 1))
        
        resetBuffer()
        bitsWritten = 0
    }
    
    private mutating func resetBuffer() {
        buffer = 0
    }
}
