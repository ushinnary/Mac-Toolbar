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
    setDefaultImagesJson()
    let data: Data

    do {
        data = try fm.read(fileNamed: filename)
    } catch {
        
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
        let additionalPathWithName = String(splitted.first!)
        let imageName = String(additionalPathWithName.split(separator: "/").last!)
        if (splitted.count < 2) {
            continue
        }
        do {
            let ext: AcceptableImageExtension? = AcceptableImageExtension(rawValue: String(splitted[1]))
            if (ext == nil) {
                throw BadFormatError.unincluded
            }
        } catch {
        continue
        }
        let location = "\(systemImagesPath)/\(fullFileName)";
        let objToAdd: StoredImage = StoredImage(name: imageName, location: location, group: _getLastFolderName(str: location), deletable: false)
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

