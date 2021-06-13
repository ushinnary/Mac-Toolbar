//
//  SidebarItem.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 15/05/2021.
//

import SwiftUI

struct SidebarItems: View {
	@EnvironmentObject var appState: AppState
	var body: some View {
		VStack {
			List {
				ForEach(appState.SidebarGroups, id: \.self) { title in
					SidebarItem(title: title)
				}
			}
			.frame(width: 200, alignment: .center)
		}
		
	}
}

struct SidebarItem: View {
	var title: String
	var body: some View {
		NavigationLink(destination: ImageList(selectedGroup: title)) {
			Text(title)
				.foregroundColor(Color("DefaultTextColor"))
		}
	}
}

struct SidebarItem_Previews: PreviewProvider {
	static var previews: some View {
		SidebarItems()
			.environmentObject(AppState.shared)
	}
}
