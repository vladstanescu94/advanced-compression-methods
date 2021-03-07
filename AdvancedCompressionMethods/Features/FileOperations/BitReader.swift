import Foundation

struct BitReader{
    public let fileName: String
    
    private var buffer: UInt8 = 0
    private var bitsRead: Int = 0
    private var fileHandle: FileHandle?
    
    public init(fileName: String) {
        self.fileName = fileName
        
        let directory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).last
        if let fileURL = directory?.appendingPathComponent(fileName),
           FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                self.fileHandle = try FileHandle(forReadingFrom: fileURL)
            } catch {
                print("Could not open file \(error)")
            }
        } else {
            print("file not found")
        }
    }
    
    public mutating func ReadNBits(numberOfBits: Int) -> UInt32? {
        guard numberOfBits > 0,
              numberOfBits <= 32 else { return nil }
        
        // TODO
        return nil
    }
    
    public mutating func ReadBit() -> CFBit {
        if isBufferEmpty() {
            if let data = self.fileHandle?.readData(ofLength: 8),
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
        self.fileHandle?.closeFile()
    }
}
