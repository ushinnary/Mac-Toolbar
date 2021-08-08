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
	private var fontColor: Color {
		return appState.image != nil ? .white : Color("DefaultTextColor")
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
					} else if appState.player != nil {
						VideoPlayer(player: appState.player)
							.frame(maxWidth: 300, minHeight: 168, maxHeight: 168)
							.onDisappear(){
								appState.player?.pause()
							}
							.padding()
					}
					Text(appState.selectedStoreImage!.name)
						.foregroundColor(fontColor)
					MediaInfo()
						.foregroundColor(fontColor)
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
			.frame(width: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
		}
		.onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
		.animation(.default)
	}
	
	
}

struct MediaInfo: View {
	@EnvironmentObject var appState: AppState
	var body: some View {
		if appState.selectedStoreImage != nil {
			Section(header: Text("Informations")) {
				LabelTextInline(label: "Name:", text: appState.selectedStoreImage!.name)
				LabelTextInline(label: "Group:", text: appState.selectedStoreImage!.group)
				LabelTextInline(label: "Size:", text: appState.selectedStoreImage!.formattedFileSize)
			}
		} else {
			EmptyView()
		}
	}
}

struct LabelTextInline: View {
	var label, text: String
	var body: some View {
		HStack(spacing: 0) {
			Text(label)
			Spacer()
			Text(text)
		}
		.padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
	}
}

struct ImageList_Previews: PreviewProvider {
	static var previews: some View {
		ImageList()
			.frame(width: 800, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
			.environmentObject(AppState.shared)
	}
}
