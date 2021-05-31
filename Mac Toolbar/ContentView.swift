//
//  ContentView.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 05/05/2021.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		VStack {
			NavigationView {
				SidebarItems()
				HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing:10){
					
					Text("Choose available image folder first")
					
				}
			}
		}
		.frame(minWidth: 800, idealWidth: .infinity, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 600, idealHeight: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
		.onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
