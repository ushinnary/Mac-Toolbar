//
//  AppDelegate.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 18/05/2021.
//
import SwiftUI
let appState = AppState.shared
let StoreContentView: some View = ContentView()
	.environmentObject(appState)
