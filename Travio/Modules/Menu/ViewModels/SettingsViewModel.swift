//
//  SettingsViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

class SettingsViewModel {
    typealias CompletionHandler = (String, Bool) -> Void
    var profile: Profile?

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

    func fetchProfile(completion: @escaping CompletionHandler) {
        NetworkManager.shared.request(TravioRouter.getProfile, responseType: Profile.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.profile = response
                completion(response.fullName, true)
            case .failure(let error):
                completion(error.localizedDescription, false)
            }
        }
    }
}
