//
//  SecurityViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 8.09.2023.
//

import Foundation
import Alamofire

class SecurityViewModel {
    
    var tableViewArray = [SecurityModel(type: "Change Password",
                                        index: ["New Password", "New Password Confirm"]),
                          SecurityModel(type: "Privacy",
                                        index: ["Camera", "Photo Library", "Location"])]
    
    typealias ChangePasswordHandler = (String, Bool) -> Void
    var changePasswordInfos: ChangePassword?
    
    func putChangePassword(change_password: String) {
        NetworkManager.shared.request(TravioRouter.putChangePassword(params: ["new_password": change_password]), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                print("Change password \(response)")
            case .failure(let error):
                print("Change Password Error: \(error.localizedDescription)")
            }
        }
    }
}
