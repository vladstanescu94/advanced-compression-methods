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
}

struct FileService: FileServiceProtocol {
    public let fileName: String
    public var fileMode: FileMode
    public let fileManager = FileManager.default
    public var fileHandle: FileHandle? = nil
    
    public init(fileName: String, fileMode: FileMode) throws {
        self.fileName = fileName
        self.fileMode = fileMode
        
        let directory = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).last
        if let fileURL = directory?.appendingPathComponent(fileName) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
            
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
    
    public func closeFileHandle() {
        self.fileHandle?.closeFile()
    }
}
