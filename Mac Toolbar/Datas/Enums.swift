//
//  Enums.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation

enum AcceptableImageExtension: String {
    case jpg, png, mp4, heic
}

enum BadFormatError: Error {
    case unincluded
}
