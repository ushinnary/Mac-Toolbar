//
//  ModelData.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation

private var didSetDefaultImages = false
private let jsonFileName = "images.json"
var systemImagesPath: String = "/System/Library/Desktop Pictures"

func loadJsonByFileName<T: Decodable>(_ filename: String = jsonFileName) throws -> T {
	let data: Data
	
	do {
		data = try fm.read(fileNamed: filename)
	} catch {
		throw AppFilesManager.Error.fileNotExists
	}
	do {
		let decoder = JSONDecoder()
		let result = try decoder.decode(T.self, from: data)
		return result
	} catch {
		throw AppFilesManager.Error.readingFailed
	}
}
func setDefaultImagesJson() -> Void {
	var jsonObjects: [StoredImage] = []
	// Getting default values
	do {
		let defaultItems: [StoredImage] = try loadJsonByFileName(jsonFileName)
		defaultItems.filter{$0.deletable}.forEach{
			jsonObjects.append($0)
		}
	} catch {
		if (!didSetDefaultImages) {
			createJsonFile(filename: jsonFileName, obj: jsonObjects)
			setDefaultImagesJson()
			didSetDefaultImages = true
		}
		
	}
	let filemanager = FileManager.default
	let files = filemanager.enumerator(atPath: systemImagesPath)
	
	while let file = files?.nextObject() {
		let fullFileName = file as! String
		let splitted = fullFileName.split(separator: ".")
		// Is hidden folder
		if fullFileName.starts(with: ".") {
			continue
		}
		let additionalPathWithName = String(splitted.first!)
		let imageName = String(additionalPathWithName.split(separator: "/").last!)
		if (splitted.count != 2) {
			continue
		}
		let location = "\(systemImagesPath)/\(fullFileName)"
		let objToAdd: StoredImage = StoredImage(name: imageName, location: location, group: _getLastFolderName(str: location), deletable: false)
		if (objToAdd.imageType == nil) {
			continue
		}
		jsonObjects.append(objToAdd)
	}
	createJsonFile(filename: jsonFileName, obj: jsonObjects)
}

func _getLastFolderName(str: String) -> String {
	let splitted = str.split(separator: "/").reversed()
	for word in splitted {
		let pathWords = word.split(separator: ".")
		// is not hidden folder
		if (pathWords.count < 2) {
			return String(word).replacingOccurrences(of: ".", with: String()).capitalized;
		}
	}
	return "";
}

func createJsonFile<T: Encodable>(filename: String, obj: T) -> Void {
	do {
		let jsonData = convertToJson(from: obj)
		try fm.save(fileNamed: filename, data: jsonData!)
	} catch {
		print(error)
	}
}

