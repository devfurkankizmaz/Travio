//
//  SettingsViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

class SettingsViewModel {
    private let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Security Settings", image: UIImage(named: "securitySettings")!),
        SettingsItem(title: "App Defaults", image: UIImage(named: "appDefaults")!),
        SettingsItem(title: "My Added Places", image: UIImage(named: "map")!),
        SettingsItem(title: "Help & Support", image: UIImage(named: "helpSupport")!),
        SettingsItem(title: "About", image: UIImage(named: "about")!),
        SettingsItem(title: "Terms of Use", image: UIImage(named: "termsOfUse")!),
    ]

    func numberOfItems() -> Int {
        return settingsItems.count
    }

    func item(at index: Int) -> SettingsItem {
        return settingsItems[index]
    }
}
