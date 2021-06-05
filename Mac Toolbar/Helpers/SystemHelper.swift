//
//  SystemHelper.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 24/05/2021.
//

import AppKit

func setSelectedAsBG()-> Void {
	if appState.selectedStoreImage == nil {return}
	if ((appState.selectedStoreImage?.isImage) != nil) {
		let imgurl = URL(fileURLWithPath: appState.selectedStoreImage!.location)
		_setBgByUrl(imgurl)
	}
}

private func _setBgByUrl(_ url: URL)-> Void {
	do {
		let workspace = NSWorkspace.shared
		if let screen = NSScreen.main  {
			guard var options = workspace.desktopImageOptions(for: screen) else {
				// handle error if no options dictionary is available for this screen
				return
			}
			// we add (or replace) our options in the dictionary
			// "size to fit" is NSImageScaling.scaleProportionallyUpOrDown
			options[NSWorkspace.DesktopImageOptionKey.imageScaling] = 3
			options[NSWorkspace.DesktopImageOptionKey.allowClipping] = true
			// finally we write the image using the new options
			try workspace.setDesktopImageURL(url, for: screen, options: options)
		}
	} catch {
		print(error)
	}
}
