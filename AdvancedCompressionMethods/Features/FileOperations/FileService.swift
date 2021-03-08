//
//  FileService.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import Foundation

public enum FileMode {
    case read
    case write
}

public enum FileServiceError: Error {
    case couldNotOpenFile
    case couldNotWriteToFile
    case couldNotReadFile
}

class FileService: FileServiceProtocol {
    // MARK: - Properties
        
    public let fileName: String
    public var fileMode: FileMode
    public let fileManager = FileManager.default
    public var fileHandle: FileHandle? = nil
    
    private var fileSize:UInt64 = 0
    
    public init(fileName: String, fileMode: FileMode) {
        self.fileName = fileName
        self.fileMode = fileMode
    }
    
    // MARK: - File Manipulation
    
    public func openFile() throws {
        let directory = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).last
        if let fileURL = directory?.appendingPathComponent(fileName) {
            if !fileManager.fileExists(atPath: fileURL.path) {
                fileManager.createFile(atPath: fileURL.path, contents: nil)
            }
            
            let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            self.fileSize = (fileAttributes[FileAttributeKey.size] as! NSNumber).uint64Value
            
            do {
                switch self.fileMode {
                case .read:
                    self.fileHandle = try FileHandle(forReadingFrom: fileURL)
                case .write:
                    self.fileHandle = try FileHandle(forWritingTo: fileURL)
                }
            } catch {
                throw FileServiceError.couldNotOpenFile
            }
        }
    }

    func writeByteToFile(data: Data) throws {
        guard fileMode == .write else { throw FileServiceError.couldNotWriteToFile}
        
        self.fileHandle?.seekToEndOfFile()
        self.fileHandle?.write(data)
    }
    
    func readByteFromFile() throws -> Data? {
        guard fileMode == .read else { throw FileServiceError.couldNotReadFile}
        
        return self.fileHandle?.readData(ofLength: 1)
    }
    
    public func closeFile() {
        self.fileHandle?.closeFile()
    }
}
