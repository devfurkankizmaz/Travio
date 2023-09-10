//
//  SettingsViewModel.swift
//  Travio
//
//  Created by Muhammet on 31.08.2023.
//

import Foundation

class SettingsViewModel {
    
    typealias getProfileHandler = (Bool) -> Void
    var profileInfos: Profile?
    public var urls: [String] = []
    
    var settingsParametres: [Settingmodel] = [Settingmodel(leftImage: "settings_user", text: "Security Settings"),
                                              Settingmodel(leftImage: "settings_default", text: "App Defaults"),
                                              Settingmodel(leftImage: "settings_place", text: "My Added Places"),
                                              Settingmodel(leftImage: "settings_help", text: "Help & Support"),
                                              Settingmodel(leftImage: "settings_about", text: "About"),
                                              Settingmodel(leftImage: "settings_term", text: "Terms of Use")
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
