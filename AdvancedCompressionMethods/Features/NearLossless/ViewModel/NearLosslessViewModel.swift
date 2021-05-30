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
    @Published var encodedFileURL: URL? = nil
    @Published var selectedPredictorType: PredictorType = .predictor0
    @Published var selectedSaveMode: ImageSaveMode = .fix
    @Published var acceptedError: Int = 0
    
    var originalImage: NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    func getOriginalImageData() -> NSImage? {
        guard let imageURL = originalImageURL else { return nil }
        
        return NSImage(contentsOf: imageURL)
    }
    
    func encode() {
        guard let imageToEncodeURL = originalImageURL else { return }
        
        let bitReader = BitReader(fileService:
                                    PopupFileService(
                                        fileURL: imageToEncodeURL,
                                        fileMode: .read))
        
        let encodedFileName = generateFileName()
        
        let bitWriter = BitWriter(fileService:
                                    FileService(
                                        fileName: encodedFileName,
                                        fileMode: .write))
        let encoder = NearLosslessEncoder(bitReader: bitReader, bitWriter: bitWriter)
        encoder.encode()
    }
    
    private func generateFileName() -> String {
        let predictorType = selectedPredictorType.rawValue
        let fileSaveMode: String
        
        switch selectedSaveMode {
        case .fix:
            fileSaveMode = "F"
        case .jpegTable:
            fileSaveMode = "T"
        case .arithmetic:
            fileSaveMode = "A"
        }
        
        let fileName = originalImageURL!.lastPathComponent
        let encodedFileName = "\(fileName).p\(predictorType)k\(acceptedError)\(fileSaveMode).prd"
        return encodedFileName
    }
    
    func decode() {
        guard let fileToDecode = encodedFileURL else { return }
        
        let bitReader = BitReader(fileService:
                                    PopupFileService(
                                        fileURL: fileToDecode,
                                        fileMode: .read))
        let bitWriter = BitWriter(fileService:
                                    FileService(
                                        fileName: "decoded.bmp",
                                        fileMode: .write))
        let decoder = NearLosslessDecoder(bitReader: bitReader, bitWriter: bitWriter)
        decoder.decode()
    }
    
}
