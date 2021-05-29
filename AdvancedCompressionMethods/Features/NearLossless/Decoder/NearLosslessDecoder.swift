//
//  NearLosslessDecoder.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import Foundation

class NearLosslessDecoder {
    
    public func decode(fileToDecode: URL?) {
        guard let url = fileToDecode else { return }
        
        print(url.path)
    }
}
