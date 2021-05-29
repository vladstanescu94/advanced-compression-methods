//
//  NearLosslessEncoder.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 22.05.2021.
//

import Foundation

class NearLosslessEncoder {
    
    public func encode(imageToEncode: URL?) {
        guard let imageURL = imageToEncode else { return }
        
        print(imageURL.path)
    }
}
