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
		if location.isEmpty {return nil}
		if location.split(separator: ".").count != 2 {return nil}
		let fullFileName = location.split(separator: "/").last!
		let splitted = fullFileName.split(separator: ".")
		// Is hidden folder
		if fullFileName.starts(with: ".") {
			return nil
		}
		let additionalPathWithName = String(splitted.first!)
		let imageName = String(additionalPathWithName.split(separator: "/").last!)
		if (splitted.count != 2) {
			return nil
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
	var size: String = String()
	var width: Int8 = Int8()
	var height: Int8 = Int8()
	var aspectRatio: String = String()
	var deletable: Bool = true
	var imageType: AcceptableImageExtension? {
		let ext = self.location.split(separator: ".").last!
		return AcceptableImageExtension(rawValue: String(ext))
	}
}
