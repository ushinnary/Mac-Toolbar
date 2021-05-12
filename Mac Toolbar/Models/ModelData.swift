//
//  ModelData.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation

private let jsonFileName = "images.json"
var systemImagesPath: String = "/System/Library/Desktop Pictures"
var lsItems: [StoredImage] = _loadJsonByFileName(jsonFileName)


private func _loadJsonByFileName<T: Decodable>(_ filename: String, _ secondCall: Bool = false) -> T {
    let data: Data

    do {
        data = try fm.read(fileNamed: filename)
    } catch {
        setDefaultImagesJson()
        if secondCall {
            fatalError("Couldn't read \(filename) from main bundle:\n\(error)")
        }
        return _loadJsonByFileName(filename, true)
    }

    do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        return result
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
func setDefaultImagesJson() -> Void {
    let filemanager = FileManager.default
    let files = filemanager.enumerator(atPath: systemImagesPath)
    var jsonObjects: [StoredImage] = []
    while let file = files?.nextObject() {
        let fullFileName = file as! String
        let splitted = fullFileName.split(separator: ".")
        let imageName = String(splitted.first!)
        //let ext = String(splitted[1])
        let objToAdd: StoredImage = StoredImage(name: imageName, location: "\(systemImagesPath)/\(fullFileName)", group: systemImagesPath, deletable: false)
        jsonObjects.append(objToAdd)
    }
    createJsonFile(filename: jsonFileName, obj: jsonObjects)
}

func createJsonFile<T: Encodable>(filename: String, obj: T) -> Void {
//    let filemanager = FileManager.default
    do {
        let jsonData = convertToJson(from: obj)
        try fm.save(fileNamed: filename, data: jsonData!)
    } catch {
        print(error)
    }
}

