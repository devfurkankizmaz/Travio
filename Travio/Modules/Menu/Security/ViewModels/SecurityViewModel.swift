//
//  SecurityViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 8.09.2023.
//

import Foundation

class SecurityViewModel {
    
    var tableViewArray = [SecurityModel(type: "Change Password",
                                                index: ["New Password", "New Password Confirm"]),
                          SecurityModel(type: "Privacy",
                                                index: ["Camera", "Photo Library", "Location"])]
    
}
