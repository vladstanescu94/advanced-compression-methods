import Foundation

struct BitWriter {
    public let fileName: String
    
    private var buffer: UInt8 = 0
    private var bitsWritten: Int = 0
    private var fileHandle: FileHandle?
    
    public init(fileName: String) {
        self.fileName = fileName
        
        let directory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).last
        if let fileURL = directory?.appendingPathComponent(fileName) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
            
            do {
                self.fileHandle = try FileHandle(forWritingTo: fileURL)
            } catch {
                print("Could not open file \(error)")
            }
        }
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
        self.fileHandle?.seekToEndOfFile()
        self.fileHandle?.write(Data(bytes: &buffer, count: 1))
        
        resetBuffer()
        bitsWritten = 0
    }
    
    private mutating func resetBuffer() {
        buffer = 0
    }
    
    public func closeFileHandle() {
        self.fileHandle?.closeFile()
    }
}
