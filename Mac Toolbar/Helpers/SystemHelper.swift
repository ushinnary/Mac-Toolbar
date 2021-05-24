//
//  SystemHelper.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 24/05/2021.
//

import Foundation
import AppKit

func setSelectedAsBG()-> Void {
    if appState.selectedStoreImage == nil {return}
    let imgurl = URL(fileURLWithPath: appState.selectedStoreImage!.location)
    do {
        let workspace = NSWorkspace.shared
        if let screen = NSScreen.main  {
            try workspace.setDesktopImageURL(imgurl, for: screen, options: [:])
        }
    } catch {
        print(error)
    }
}
