//
//  PopupFileService.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 30.05.2021.
//

import Foundation

class PopupFileService: FileServiceProtocol {
    // MARK: - Properties
        
    public let fileURL: URL
    public var fileMode: FileMode
    public let fileManager = FileManager.default
    public var fileHandle: FileHandle? = nil
    public var fileSize:UInt64 = 0
    
    public init(fileURL: URL, fileMode: FileMode) {
        self.fileURL = fileURL
        self.fileMode = fileMode
    }
    
    // MARK: - File Manipulation
    
    public func openFile() {
        getFileSize(path: fileURL.path)
        
        do {
            try self.createFileHandle(fileURL: fileURL)
        } catch {
            print("Can't create file handle")
        }
    }
    
    private func getFileSize(path: String) {
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: path)
            self.fileSize = (fileAttributes[FileAttributeKey.size] as! NSNumber).uint64Value
        } catch {
            print("Can't read file size")
        }
    }
    
    private func createFileHandle(fileURL: URL) throws {
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
