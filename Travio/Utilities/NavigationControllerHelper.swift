//
//  NavigationControllerHelper.swift
//  Travio
//
//  Created by Furkan Kızmaz on 11.09.2023.
//

import JWTDecode
import UIKit

class NavigationControllerHelper {
    static func navigateToAppropriateScreen(window: UIWindow?, token: String?) {
        if let token = token, !token.isEmpty {
            if isTokenExpired(token: token) {
                showLoginScreen(window: window)
            } else {
                showMainTabBarScreen(window: window)
            }
        } else {
            showLoginScreen(window: window)
        }
    }

    static func isTokenExpired(token: String) -> Bool {
        do {
            let jwt = try decode(jwt: token)
            let expirationDate = jwt.expiresAt
            let currentDate = Date()
            if let expirationDate = expirationDate, currentDate > expirationDate {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    static func showMainTabBarScreen(window: UIWindow?) {
        let mainTabBarController = MainTabBarController()
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    static func showLoginScreen(window: UIWindow?) {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
