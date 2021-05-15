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
                if let img = NSImage(contentsOf: url) {
                    Image(nsImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                    Text(imgObj.name)
                        .font(.caption)
                        
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
