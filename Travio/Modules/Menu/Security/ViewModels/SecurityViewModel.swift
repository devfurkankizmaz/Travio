//
//  SecurityViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 8.09.2023.
//

import Foundation

class SecurityViewModel {
    var sections: [Section] = []

    init() {
        let changePasswordItems: [Item] = [
            Item(type: .textInput("New Password", "Enter your new password")),
            Item(type: .textInput("New Password Confirm", "Confirm your new password")),
        ]

        let changePasswordSection = Section(title: "Change Password", items: changePasswordItems)

        let privacyItems: [Item] = [
            Item(type: .switchItem("Camera")),
            Item(type: .switchItem("Photo Library")),
            Item(type: .switchItem("Location")),
        ]

        let privacySection = Section(title: "Privacy", items: privacyItems)

        self.sections = [changePasswordSection, privacySection]
    }
}
