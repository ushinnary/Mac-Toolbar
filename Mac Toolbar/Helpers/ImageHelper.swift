//
//  ImageHelper.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 15/05/2021.
//

import AppKit
import Combine

let defaultImageSize = 300

extension NSImage {
	
	func resizedImageTo(sourceImage: NSImage, newSize: NSSize) -> NSImage? {
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
	
	func resizedImageCGI(fromUrl: URL) -> NSImage? {
		guard let img = NSImage(contentsOf: fromUrl) else {
			return nil
		}
		return resized(size: getOptimizedImageSize(img: img))
	}
	
	var cgImage: CGImage? {
		get {
			guard let imageData = self.tiffRepresentation else {
				return nil
			}
			guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else {
				return nil
			}
			return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
		}
	}
	
	// TOO EXPENSIVE IN RAM
	func resized(size: NSSize?) -> NSImage {
		let sizeToUse = size ?? getOptimizedImageSize(img: self)
		let intSize = NSSize(width: Int(sizeToUse.width), height: Int(sizeToUse.height))
		let cgImage = self.cgImage!
		let bitsPerComponent = cgImage.bitsPerComponent
		let colorSpace = cgImage.colorSpace!
		let bitmapInfo = CGImageAlphaInfo.noneSkipLast
		let context = CGContext(data: nil,
								width: Int(intSize.width),
								height: Int(intSize.height),
								bitsPerComponent: bitsPerComponent,
								bytesPerRow: 0,
								space: colorSpace,
								bitmapInfo: bitmapInfo.rawValue)!
		
		context.interpolationQuality = .high
		context.draw(cgImage,
					 in: NSRect(x: 0, y: 0, width: intSize.width, height: intSize.height))
		let img = context.makeImage()!
		return NSImage(cgImage: img, size: intSize)
	}
}

func getOptimizedImageSize(img: NSImage) -> NSSize {
	let maxImageSize = CGFloat(defaultImageSize)
	var width = img.size.width
	var height = img.size.height
	if (width <= maxImageSize && height <= maxImageSize) {
		return img.size
	}
	let aspectRatio = width / height
	if (width > height) {
		width = maxImageSize
		height = width / aspectRatio
	} else {
		height = maxImageSize
		width = height / aspectRatio
	}
	return NSSize(width: width, height: height)
}

func getNSSizeFromInt(num: Int = defaultImageSize) -> NSSize {
	let width = CGFloat(num)
	let height = CGFloat(width / 16 * 9)
	return NSSize(width: width, height: height)
}

import ImageIO

// Technique #3
func resizedImage(at url: URL, for size: CGSize = getNSSizeFromInt()) -> NSImage? {
	let options: [CFString: Any] = [
		kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
		kCGImageSourceCreateThumbnailWithTransform: true,
		kCGImageSourceShouldCacheImmediately: true,
		kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
	]
	
	guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
		  let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
	else {
		return nil
	}
	
	return NSImage(cgImage: image, size: size)
}

func getOptimizedImg(imgObj: StoredImage) -> NSImage? {
	let url = URL(fileURLWithPath: imgObj.location)
	return resizedImage(at: url)
}

func getOriginalImage(imgObj: StoredImage) -> NSImage? {
	let url = URL(fileURLWithPath: imgObj.location)
	return NSImage(contentsOf: url)
}


