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
//        if fileManager.fileExists(atPath: url.absoluteString) {
//            throw Error.fileAlreadyExists
//        }
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
//        guard fileManager.fileExists(atPath: url.absoluteString) else {
//            throw Error.fileNotExists
//        }
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

