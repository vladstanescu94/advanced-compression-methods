//
//  FileServiceProtocol.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import Foundation

public protocol FileServiceProtocol {
    func openFile()
    func writeByteToFile(data: Data) throws
    func readByteFromFile() throws -> Data?
    func closeFile()
}
