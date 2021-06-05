//
//  ImageStruct.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation
import AppKit

struct StoredImage: Hashable, Codable, Identifiable {
	init?(fullFileName: String) {
		self.init(location: "\(systemImagesPath)/\(fullFileName)")
	}
	init?(location: String, deletable: Bool = false) {
		if location.isEmpty || !fm.fileManager.fileExists(atPath: location) {return nil}
		if location.split(separator: ".").count != 2 {return nil}
		let fullFileName = location.split(separator: "/").last!
		let nameAndExtension = fullFileName.split(separator: ".")
		// Is hidden folder
		if fullFileName.starts(with: ".") {
			return nil
		}
		let additionalPathWithName = String(nameAndExtension.first!)
		let imageName = String(additionalPathWithName.split(separator: "/").last!)
		if (nameAndExtension.count != 2) {
			return nil
		}
		do {
			let attrs = try fm.fileManager.attributesOfItem(atPath: location)
			let dict = attrs as NSDictionary

			self.size = getFileSizeInBytes(size: dict.fileSize())
		} catch {
			self.size = String()
		}

		self.location = location
		self.name = imageName
		self.group = _getLastFolderName(str: self.location)
		self.deletable = deletable
	}
	enum AcceptableImageExtension: String {
		case jpg, png, mp4, heic
	}
	var id = UUID()
	var name, location, group: String
	var size: String =  String()
	var width: Int8 = Int8()
	var height: Int8 = Int8()
	var aspectRatio: String = String()
	var deletable: Bool = true
	var imageType: AcceptableImageExtension? {
		let ext = self.location.split(separator: ".").last!
		return AcceptableImageExtension(rawValue: String(ext))
	}
	
	var isVideo: Bool {
		if self.imageType == nil {return false}
		let videoTypes: [AcceptableImageExtension] = [.mp4]
		return videoTypes.contains(self.imageType!)
	}
	
	var isImage: Bool {
		if self.imageType == nil {return false}
		let imgTypes: [AcceptableImageExtension] = [.heic, .jpg, .png]
		return imgTypes.contains(self.imageType!)
	}
	
	var url: URL? {
		return URL(fileURLWithPath: self.location)
	}
}
