//
//  SettingsViewModel.swift
//  Travio
//
//  Created by Muhammet on 31.08.2023.
//

import Foundation

class SettingsViewModel {
    
    var settingsParametres: [Settingmodel] = [Settingmodel(leftImage: "settings_user", text: "Security Settings"),
                                              Settingmodel(leftImage: "settings_default", text: "App Defaults"),
                                              Settingmodel(leftImage: "settings_place", text: "My Added Places"),
                                              Settingmodel(leftImage: "settings_help", text: "Help & Support"),
                                              Settingmodel(leftImage: "settings_about", text: "About"),
                                              Settingmodel(leftImage: "settings_term", text: "Terms of Use")
    ]
}
