//
//  ImageHelper.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 15/05/2021.
//

import AppKit
extension NSImage {
    
    func resizedImageTo(sourceImage: NSImage, newSize: NSSize) -> NSImage?{
        if sourceImage.isValid == false {
            return nil
        }
        let representation = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)
        representation?.size = newSize
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext.init(bitmapImageRep: representation!)
        sourceImage.draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: NSZeroRect, operation: .copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(representation!)
        
        return newImage
        
    }
    
    func resizedImageTo(fromUrl: URL) -> NSImage? {
        guard let img = NSImage(contentsOf: fromUrl) else {
            return nil
        }
        return resizedImageTo(sourceImage: img, newSize: getOptimizedImageSize(img: img))
    }
    
 
}

func getOptimizedImageSize(img: NSImage) ->NSSize {
    let maxImageSize = CGFloat(500)
    var width = img.size.width
    var height = img.size.height
    if (width <= maxImageSize && height <= maxImageSize) {return img.size}
    let aspectRatio = width/height
    if (width > height) {
        width = maxImageSize
        height = width/aspectRatio
    } else {
        height =  maxImageSize
        width = height/aspectRatio
    }
    return NSSize(width: width, height: height)
}
