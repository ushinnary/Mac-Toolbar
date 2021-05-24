//
//  AppState.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 18/05/2021.
//

import AppKit
class AppState: ObservableObject {
    
    // 1
    static let shared = AppState()
    private init() {
        lsItems =  try! loadJsonByFileName()
    }
    
    // 2
//    @Published var image: NSImage? {
//        didSet {
//            // 4
//            self.selectedStoreImage = nil
//        }
//    }
        
    // 3
    @Published var selectedStoreImage: StoredImage?
    @Published var lsItems: [StoredImage] = []
}
