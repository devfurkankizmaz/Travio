//
//  SecurityModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 8.09.2023.
//

import Foundation

struct Section {
    let title: String
    let items: [Item]
}

struct Item {
    let type: ItemType
}

enum ItemType {
    case textInput(String, String)
    case switchItem(String)
}
