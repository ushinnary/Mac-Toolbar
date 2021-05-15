//
//  ImageStruct.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import Foundation

struct StoredImage: Hashable, Codable {
//    init?(name: String, location: String, group: String, size: String = String(), width: Int8 = Int8(), height: Int8 = Int8(), aspectRatio: String = String(), deletable: Bool = true, imageType: String) {
//        guard let imgExt = AcceptableImageExtension(rawValue: imageType) else {
//            return nil
//        }
//        self.name = name
//        self.location = location
//        self.group = group
//        self.size = size
//        self.width = width
//        self.height = height
//        self.aspectRatio = aspectRatio
//        self.deletable = deletable
//        self.imageType = imgExt
//    }
    
    var name, location, group: String
    var size: String = String()
    var width: Int8 = Int8()
    var height: Int8 = Int8()
    var aspectRatio: String = String()
    var deletable: Bool = true
    //var imageType: AcceptableImageExtension
}
