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
fileprivate func updateJson(_ files: FileManager.DirectoryEnumerator?, _ jsonObjects: inout [StoredImage]) {
	while let file = files?.nextObject() {
		let fullFileName = file as! String
		guard let objToAdd: StoredImage = StoredImage(fullFileName: fullFileName) else {continue}
		if (objToAdd.imageType == nil) {
			continue
		}
		jsonObjects.append(objToAdd)
	}
	createJsonFile(filename: jsonFileName, obj: jsonObjects)
	appState.lsItems = try! loadJsonByFileName()
}

fileprivate func updateJsonByLocation(_ files: FileManager.DirectoryEnumerator?, _ jsonObjects: inout [StoredImage], location: String) {
	while let file = files?.nextObject() {
		let fileName = file as! String
		let fullFileName = "\(location)\(fileName)"
		if jsonObjects.contains(where: {$0.location == fullFileName}) {
//			jsonObjects = jsonObjects.filter{$0.location != fullFileName}
			continue
		}
		guard let objToAdd: StoredImage = StoredImage(location: fullFileName, deletable: true) else {continue}
		if (objToAdd.imageType == nil) {
			continue
		}
		jsonObjects.append(objToAdd)
	}
	createJsonFile(filename: jsonFileName, obj: jsonObjects)
	appState.lsItems = try! loadJsonByFileName()
}

func setDefaultImagesJson() -> Void {
	var jsonObjects: [StoredImage] = []
	// Getting default values
	do {
		let defaultItems: [StoredImage] = try loadJsonByFileName()
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
	let files = _getItemsFromPath(atPath: systemImagesPath)
	updateJson(files, &jsonObjects)
}

func addOrRemoveFileToJson(location: String, isFolder: Bool = false) -> Void {
	var items = _getCurrentItems(location: location)
	let files = _getItemsFromPath(atPath: location)
	if isFolder {
		updateJsonByLocation(files, &items, location: location)
	} else {
		updateJson(files, &items)
	}
}

private func _getCurrentItems(location: String)-> [StoredImage] {
	var currentItems: [StoredImage] = try! loadJsonByFileName()
	
	if !currentItems.contains(where: {$0.location == location}) {
		if let itemToAdd = StoredImage(location: location, deletable: true) {
			currentItems.append(itemToAdd)
		}
	} else {
//		currentItems = currentItems.filter{$0.location != location}
	}
	return currentItems
}

func _getItemsFromPath(atPath: String) -> FileManager.DirectoryEnumerator?{
	let filemanager = FileManager.default
	return filemanager.enumerator(atPath: atPath)
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

