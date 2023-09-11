//
//  SettingsViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

class SettingsViewModel {
    
    typealias getProfileHandler = (Bool) -> Void
    var profileInfos: Profile?
    public var urls: [String] = []
    
    var settingsParametres: [SettingsModel] = [SettingsModel(leftImage: "securitySettings", text: "Security Settings"),
                                               SettingsModel(leftImage: "appDefaults", text: "App Defaults"),
                                               SettingsModel(leftImage: "addPlaces", text: "My Added Places"),
                                               SettingsModel(leftImage: "helpSupport", text: "Help & Support"),
                                               SettingsModel(leftImage: "about", text: "About"),
                                               SettingsModel(leftImage: "termsOfUse", text: "Terms of Use")
    ]
    
    
    func getProfile(callback: @escaping getProfileHandler) {
        NetworkManager.shared.request(TravioRouter.getProfileInfo, responseType: Profile.self) { result in
            switch result {
            case .success(let response):
                print(response)
                self.profileInfos = response
                callback(true)
            case .failure(let error):
                print(error)
                callback(false)
            }
        }
    }
    
    
}
