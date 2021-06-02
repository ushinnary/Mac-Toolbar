//
//  FileHelper.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 09/05/2021.
//

import Foundation

let fm = AppFilesManager.init()

func convertToJson<T : Encodable>(from object:T) -> Data? {
	let jsonData = try? JSONEncoder().encode(object)
	return Data(String(data: jsonData!, encoding: .utf8)!.utf8)
}

class AppFilesManager {
	enum Error: Swift.Error {
		case fileAlreadyExists
		case invalidDirectory
		case writtingFailed
		case fileNotExists
		case readingFailed
	}
	let fileManager: FileManager
	init(fileManager: FileManager = .default) {
		self.fileManager = fileManager
	}
	func save(fileNamed: String, data: Data) throws {
		guard let url = getFileUrl(forFileNamed: fileNamed) else {
			throw Error.invalidDirectory
		}
		do {
			try data.write(to: url)
		} catch {
			debugPrint(error)
			throw Error.writtingFailed
		}
	}
	func read(fileNamed: String) throws -> Data {
		guard let url = getFileUrl(forFileNamed: fileNamed) else {
			throw Error.invalidDirectory
		}
		do {
			return try Data(contentsOf: url)
		} catch {
			debugPrint(error)
			throw Error.readingFailed
		}
	}
	func getFileUrl(forFileNamed fileName: String) -> URL? {
		guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}
		return url.appendingPathComponent(fileName)
	}
}


func handleOnDrop(providers: [NSItemProvider]) -> Bool {
	if providers.isEmpty {return false}
	providers.forEach{item in
		item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
			DispatchQueue.main.async {
				if let urlData = urlData as? Data {
					let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
					let isFolder = url.absoluteString.hasSuffix("/")
					let cleanedURL: String = url.absoluteString
						.replacingOccurrences(of: "file://", with: String())
						.replacingOccurrences(of: "%20", with: " ")
					addOrRemoveFileToJson(location: cleanedURL, isFolder: isFolder)
				}
			}
		}
	}
	return true
}
