//
//  SceneDelegate.swift
//  Travio
//
//  Created by Furkan Kızmaz on 18.08.2023.
//

import Alamofire
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)

        let viewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()

        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationController.navigationBar.tintColor = .white

        if let token = KeychainHelper.loadAccessToken() {
            isTokenValid(token) { isValid in
                if isValid {
                    self.openMainTabBarController()
                } else {
                    self.redirectToLoginScreen()
                }
            }
        } else {
            redirectToLoginScreen()
        }
    }

    func isTokenValid(_ token: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.request(TravioRouter.getProfile, responseType: Profile.self) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func openMainTabBarController() {
        let mainTabBarController = MainTabBarController()
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.setViewControllers([mainTabBarController], animated: true)
        }
    }

    func redirectToLoginScreen() {
        let loginViewController = LoginViewController()
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.setViewControllers([loginViewController], animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
