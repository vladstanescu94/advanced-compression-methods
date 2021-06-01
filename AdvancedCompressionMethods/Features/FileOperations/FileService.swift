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
    public var fileSize:UInt64 = 0
    public var fileURL: URL? = nil
    
    public init(fileName: String, fileMode: FileMode) {
        self.fileName = fileName
        self.fileMode = fileMode
    }
    
    // MARK: - File Manipulation
    
    public func openFile() {
        let directory = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).last
        if let fileURL = directory?.appendingPathComponent(fileName) {
            createFile(path: fileURL.path)
            getFileSize(path: fileURL.path)
            self.fileURL = fileURL
            
            do {
                try self.createFileHandle(fileURL: fileURL)
            } catch {
                print("Can't create file handle")
            }
        }
    }
    
    private func createFile(path: String) {
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil)
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
