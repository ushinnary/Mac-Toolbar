//
//  AppState.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 18/05/2021.
//

import AppKit

class AppState: ObservableObject {
	static let shared = AppState()
	private init() {
		lsItems =  try! loadJsonByFileName()
	}
	@Published private(set) var image: NSImage? 
	@Published  private(set) var video: NSObject?
	@Published var selectedStoreImage: StoredImage?
	@Published var lsItems: [StoredImage] = []
	
	var SidebarGroups: [String] {
		return Array(Set(appState.lsItems.map{$0.group})).sorted { $0 < $1 }
	}
	
	func setImage(img: NSImage?)-> Void {
		if self.selectedStoreImage == nil {
			self.image = nil
			return
		}
		self.image = img
		self.video = nil
	}
	
	func setVideo(video: NSObject?)-> Void {
		if self.selectedStoreImage == nil {
			self.video = nil
			return
		}
		self.video = video
		self.image = nil
	}
}
