//
//  ProfileModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Foundation

struct Profile: Codable {
    let full_name: String
    let email: String
    let pp_url: String
    let role: String
    let created_at: String
}

