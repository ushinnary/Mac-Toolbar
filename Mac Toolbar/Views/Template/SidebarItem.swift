//
//  SidebarItem.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 15/05/2021.
//

import SwiftUI

struct SidebarItems: View {
    private let titles = Array(Set(lsItems.map{$0.group}))
    var body: some View {
        List {
            ForEach(titles, id: \.self) { title in
                SidebarItem(title: title)
            }
        }.frame(width: 200, alignment: .center)
    }
}

struct SidebarItem: View {
    var title: String
    var body: some View {
        NavigationLink(destination: ImageList(selectedGroup: title)) {
            Text(title)
                .foregroundColor(Color("DefaultTextColor"))
        }
    }
}

struct SidebarItem_Previews: PreviewProvider {
    static var previews: some View {
        SidebarItems()
    }
}
