//
//  FileServiceProtocol.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 07.03.2021.
//

import Foundation

public protocol FileServiceProtocol {
    var fileHandle: FileHandle? { get set }
    var fileMode: FileMode { get set }
    func closeFileHandle()
}
