//
//  Chip.swift
//  fundamental-sub-one
//
//  Created by Abdul Chathil on 7/2/20.
//  Copyright © 2020 Abdul Chathil. All rights reserved.
//

import SwiftUI

struct Chip: View {
    let text: String
    var body: some View {
        Text(text).font(.caption)
            .fontWeight(.regular).foregroundColor(.black).lineLimit(1)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)).background(Color("primary")).clipShape(Capsule())
    }
}

struct Chip_Previews: PreviewProvider {
    static var previews: some View {
        Chip(text: "Hello World")
    }
}
