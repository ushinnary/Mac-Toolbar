//
//  Mac_ToolbarApp.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 05/05/2021.
//

import SwiftUI

@main
struct Mac_ToolbarApp: App {
    init() {
        setDefaultImagesJson()
    }

    var body: some Scene {
        WindowGroup {
            StoreContentView
        }
    }
}
