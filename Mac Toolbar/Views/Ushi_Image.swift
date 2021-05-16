//
//  CircleImage.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 06/05/2021.
//

import SwiftUI
import AppKit

struct Ushi_Image: View {
    var imgObj: StoredImage
    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(fileURLWithPath: imgObj.location) {
                if let img = NSImage().resizedImageTo(fromUrl: url) {
                    Image(nsImage: img)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                    Spacer()
                    Text(imgObj.name)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(15)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        Ushi_Image(imgObj: lsItems[0])
            .padding(.vertical)
    }
}
