import Foundation
import Cocoa

func openFileFromPanel(allowedExtensions: [String], completion: @escaping (URL?) -> Void) {
    let openPanel = NSOpenPanel()
    
    openPanel.prompt = "Select File"
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = true
    openPanel.allowedFileTypes = allowedExtensions
    openPanel.begin { (result) -> Void in
        if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
            completion(openPanel.url)
        }
    }
}
