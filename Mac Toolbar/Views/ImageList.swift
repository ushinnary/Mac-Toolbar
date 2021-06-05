//
//  ImageList.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import SwiftUI
import AVKit

struct ImageList: View {
	var selectedGroup: String?
	@EnvironmentObject var appState: AppState
	private var items:  [StoredImage]  {
		return selectedGroup == nil ? appState.lsItems :
			appState.lsItems.filter{item in
				return  item.group == selectedGroup
			}
	}
	let columns = [
		GridItem(.adaptive(minimum: 200, maximum: 200), spacing: 50, alignment: .center)
	]
	var body: some View {
		HStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(items, id: \.location) { item in
						ImageItem(imgObj: item)
					}
				}
				.padding(.horizontal)
			}
			.frame(maxWidth: .infinity)
			VStack {
				if appState.selectedStoreImage != nil {
					if appState.image != nil {
						Image(nsImage: appState.image!)
							.resizable()
							.scaledToFit()
							.cornerRadius(10)
							.padding()
					} else if appState.video != nil {
						VideoPlayer(player: appState.video! as? AVPlayer)
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: 300, minHeight: 168, maxHeight: 168)
						Text(appState.selectedStoreImage!.name)
					}
					Section(header: Text("Informations")) {
						Text("Name: ")
					}
					Button(action: setSelectedAsBG) {
						Text("Set as background")
					}
					Spacer()
				} else {
					Spacer()
					Text("Select image")
					Spacer()
				}
			}
			.frame(maxWidth: 300, maxHeight: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
		}
		.onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
		.background(
			appState.image != nil
				? Image(nsImage: appState.image!)
				.resizable()
				.blur(radius: 10.0)
				.overlay(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
			: nil
		)
		
	}
	
	
}

struct ImageList_Previews: PreviewProvider {
	static var previews: some View {
		ImageList()
			.frame(width: 800, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
			.environmentObject(AppState.shared)
	}
}
