//
//  ResponseModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import Foundation

struct ResponseModel: Codable {
    let status: String
    let message: String
}

struct CheckModel: Codable {
    let status: String
    let message: Bool
}
