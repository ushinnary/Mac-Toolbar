//
//  ContentView.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 05/05/2021.
//

import SwiftUI
import AVKit

struct ContentView: View {
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		HStack {
			NavigationView {
				SidebarItems()
				HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
					Text("Choose available image folder first")
				}
			}
			.navigationViewStyle(DoubleColumnNavigationViewStyle())
		}
		.frame(minWidth: 800, idealWidth: .infinity, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 600, idealHeight: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
		.onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
		.background(
			BackgroundMedia()
		)
	}
}

struct BackgroundMedia: View {
	@EnvironmentObject var appState: AppState
	var body: some View {
		if appState.image != nil {
			Image(nsImage: appState.image!)
				.resizable()
				.blur(radius: 10.0)
				.overlay(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
		} else if appState.player != nil {
			VideoPlayer(player: appState.player)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.blur(radius: 10.0)
				.overlay(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
				.onAppear() {
					appState.player?.play()
					appState.player?.volume = 0
				}
				.onDisappear() {
					appState.player?.pause()
				}
		} else {
			EmptyView()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environmentObject(AppState.shared)
	}
}
