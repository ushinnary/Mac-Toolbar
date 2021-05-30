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
	@Published var image: NSImage?
	
	// 3
	@Published var selectedStoreImage: StoredImage? {
		didSet {
			//			guard selectedStoreImage != nil else {return}
			//			DispatchQueue.global().async {
			//				let url = URL(fileURLWithPath: (self.selectedStoreImage?.location)!)
			//				guard let img = resizedImage(at: url) else {
			//					return
			//				}
			//				DispatchQueue.main.async {
			//					self.image = img
			//				}
			//			}
		}
	}
	@Published var lsItems: [StoredImage] = []
}
