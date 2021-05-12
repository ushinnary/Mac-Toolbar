//
//  MainTemplate.swift
//  Mac Toolbar
//
//  Created by Alexander Kartushin on 08/05/2021.
//

import SwiftUI

struct MainTemplate: View {
    var body: some View {
        HStack {
            // Sidebard
            VStack {
                Text("Sidebar")
                    .padding()
                    Spacer()
            }
        }
        .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
    }
}

struct MainTemplate_Previews: PreviewProvider {
    static var previews: some View {
        MainTemplate()
    }
}
