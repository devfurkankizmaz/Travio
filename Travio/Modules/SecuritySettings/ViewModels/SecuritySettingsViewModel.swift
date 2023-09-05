//
//  SecuritySettingsViewModel.swift
//  Travio
//
//  Created by Muhammet on 3.09.2023.
//

import Foundation

class SecuritySettingsViewModel {
    
    var tableViewArray = [SecuritySettingsModel(type: "Change Password",
                                                index: ["New Password", "New Password Confirm"]),
                          SecuritySettingsModel(type: "Privacy",
                                                index: ["Camera", "Photo Library", "Location"])]
    
}
