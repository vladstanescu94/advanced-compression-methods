//
//  NearLosslessViewModel.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 29.05.2021.
//

import Foundation
import Cocoa

class NearLosslessViewModel: ObservableObject {
    @Published var originalImageURL: URL? = nil
    @Published var selectedPredictorType: PredictorType = .predictor0
    @Published var selectedSaveMode: ImageSaveMode = .fix
    @Published var acceptedError: Int = 0
    
    @Published var domainMinValue: Int = 0 {
        didSet {
            if domainMinValue > 255 {
                domainMinValue = 255
            }
            if domainMinValue < 0 {
                domainMinValue = 0
            }
        }
    }
    
    @Published var domainMaxValue: Int = 0 {
        didSet {
            if domainMaxValue > 255 {
                domainMaxValue = 255
            }
            if domainMaxValue < 0 {
                domainMaxValue = 0
            }
        }
    }
    
    let encoder = NearLosslessEncoder()
    let decoder = NearLosslessDecoder()
    
    var originalImage: NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    func getOriginalImageData() -> NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
}
