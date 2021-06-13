//
//  CircleImage.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 06/05/2021.
//

import SwiftUI
import AppKit
import AVKit

struct ImageItem: View {
	var imgObj: StoredImage
	@State private var image: NSImage? = nil
	@EnvironmentObject var appState: AppState
	private var isActive: Bool {
		return imgObj.location == appState.selectedStoreImage?.location
	}
	var body: some View {
		VStack(alignment: .center) {
			Spacer()
			if image != nil {
				Image(nsImage: image!)
					.resizable()
					.scaledToFit()
					.cornerRadius(10)
					.overlay(
						isActive ? RoundedRectangle(cornerRadius: 10)
							.stroke(Color.accentColor, lineWidth: 4) : nil
					)
			} else if imgObj.isVideo{
				VideoPlayer(player: AVPlayer(url:  imgObj.url!))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				Spinner()
			}
			Spacer()
			HStack {
				Text(imgObj.name)
					.font(.subheadline)
					.cornerRadius(10)
					.foregroundColor(appState.image != nil ? .white : Color("DefaultTextColor"))
				Spacer()
			}
			
		}
		.onAppear(perform: {
			if imgObj.isImage {
				renderImage()
			}
		})
		.onTapGesture {
			appState.selectedStoreImage = !isActive ? imgObj : nil
			if imgObj.isVideo {
				appState.setVideo(video: AVPlayer(url:  imgObj.url!))
			} else {
				appState.setImage(img: image)
			}
		}
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
		ImageItem(imgObj: AppState.shared.lsItems.first!)
			.padding(.vertical)
			.environmentObject(AppState.shared)
	}
}
