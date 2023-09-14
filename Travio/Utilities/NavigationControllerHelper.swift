//
//  NavigationControllerHelper.swift
//  Travio
//
//  Created by Furkan Kızmaz on 11.09.2023.
//

import Alamofire
import UIKit

class NavigationControllerHelper {
    static func navigateToAppropriateScreen(window: UIWindow?, token: String?) {
        if let token = token, !token.isEmpty {
            checkTokenValidity { confirm in
                if confirm {
                    showMainTabBarScreen(window: window)
                } else {
                    refreshAccessToken { success in
                        if success {
                            showMainTabBarScreen(window: window)
                        } else {
                            showLoginScreen(window: window)
                        }
                    }
                }
            }
        } else {
            showLoginScreen(window: window)
        }
    }

    private static func checkTokenValidity(callback: @escaping (Bool) -> Void) {
        NetworkManager.shared.request(TravioRouter.getProfile, responseType: Profile.self) { result in
            switch result {
            case .success:
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    private static func refreshAccessToken(callback: @escaping (Bool) -> Void) {
        let param: Parameters = ["refresh_token": KeychainHelper.loadRefreshToken()!]
        NetworkManager.shared.request(TravioRouter.refresh(params: param), responseType: LoginResponse.self) { result in
            switch result {
            case .success(let result):
                KeychainHelper.saveAccessToken(result.accessToken)
                KeychainHelper.saveRefreshToken(result.refreshToken)
                print(result.refreshToken)
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    private static func showMainTabBarScreen(window: UIWindow?) {
        let mainTabBarController = MainTabBarController()
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private static func showLoginScreen(window: UIWindow?) {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
