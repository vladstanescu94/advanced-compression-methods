import Foundation

struct BitReader{
    public let fileService: FileServiceProtocol
    
    private var buffer: UInt8 = 0
    private var bitsRead: Int = 0
    
    public init(fileService: FileServiceProtocol) {
        self.fileService = fileService
    }
    
    public mutating func ReadNBits(numberOfBits: Int) -> UInt32? {
        guard numberOfBits > 0,
              numberOfBits <= 32 else { return nil }
        
        // TODO
        return nil
    }
    
    public mutating func ReadBit() -> CFBit {
        if isBufferEmpty() {
            if self.fileService.fileMode == .read,
               let data = self.fileService.fileHandle?.readData(ofLength: 8),
               data.isEmpty == false {
                buffer = UInt8(data[0])
                bitsRead = 8
            }
        }
        
        bitsRead -= 1
        let bit: CFBit = CFBit((buffer >> bitsRead) & 0x01)
        return bit
    }
    
    public func isBufferEmpty() -> Bool {
        return bitsRead == 0
    }
    
    private mutating func resetBuffer() {
        buffer = 0
    }
    
    public func closeFileHandle() {
        self.fileService.fileHandle?.closeFile()
    }
}
