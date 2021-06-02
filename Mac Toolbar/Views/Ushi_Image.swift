//
//  CircleImage.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 06/05/2021.
//

import SwiftUI
import AppKit

struct Ushi_Image: View {
	var imgObj: StoredImage
	@State private var image: NSImage? = nil
	@EnvironmentObject var appState: AppState
	private var isActive: Bool {
		return imgObj.location == appState.selectedStoreImage?.location
	}
	var body: some View {
		VStack(alignment: .leading) {
			if image != nil {
				Spacer()
				Image(nsImage: image!)
					.resizable()
					.scaledToFit()
					.cornerRadius(10)
					.overlay(
						isActive ? RoundedRectangle(cornerRadius: 10)
							.stroke(Color.accentColor, lineWidth: 4) : nil
					)
					.onTapGesture {
						appState.selectedStoreImage = !isActive ? imgObj : nil
						appState.image = appState.selectedStoreImage == nil ? nil : image
					}
				Spacer()
				HStack {
					Text(imgObj.name)
						.font(.caption)
					Spacer()
				}
				
			} else {
				Spinner()
			}
		}
		.onAppear(perform: {
			renderImage()
		})
		.padding(15)
	}
	
	func renderImage() {
		if image != nil {return}
		let url = URL(fileURLWithPath: imgObj.location)
		DispatchQueue.global().async {
			guard let img = resizedImage(at: url) else {
				return
			}
			DispatchQueue.main.async {
				image = img
			}
		}
		
	}
	
}

struct CircleImage_Previews: PreviewProvider {
	@EnvironmentObject var appState: AppState
	static var previews: some View {
		Ushi_Image(imgObj: AppState.shared.lsItems.first!)
			.padding(.vertical)
			.environmentObject(AppState.shared)
	}
}
