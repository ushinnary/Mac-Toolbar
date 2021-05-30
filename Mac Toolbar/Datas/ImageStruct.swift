//
//  ImageStruct.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation
import AppKit

struct StoredImage: Hashable, Codable, Identifiable {
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
