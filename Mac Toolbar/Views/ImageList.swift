//
//  ImageList.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import SwiftUI

struct ImageList: View {
    let columns = [
        GridItem(.adaptive(minimum: 300, maximum: 300), spacing: 50, alignment: .center)
        ]
    var body: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(lsItems, id: \.location) { item in
                            Ushi_Image(imgObj: item)
                        }
                    }
                    .padding(.horizontal)
                }
        
    }
}

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
        ImageList()
    }
}
