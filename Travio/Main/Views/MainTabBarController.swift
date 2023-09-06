import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let homeVC = HomeViewController()
        let homeNC = createNavigationController(rootViewController: homeVC, title: "Home", imageName: "house.fill")

        let visitsVC = VisitsViewController()
        let visitsNC = createNavigationController(rootViewController: visitsVC, title: "Visits", imageName: "location")

        let mapVC = MapViewController()
        let mapNC = createNavigationController(rootViewController: mapVC, title: "Map", imageName: "map")

        let menuVC = SettingsViewController()
        let menuNC = createNavigationController(rootViewController: menuVC, title: "Menu", imageName: "menu")

        viewControllers = [homeNC, visitsNC, mapNC, menuNC]
        selectedIndex = 0

        customizeTabBarAppearance()
    }

    private func createNavigationController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)

        if let image = UIImage(named: imageName) {
            navigationController.tabBarItem = UITabBarItem(title: title, image: image, tag: viewControllers?.count ?? 0)
        } else {
            navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: viewControllers?.count ?? 0)
        }

        return navigationController
    }

    private func customizeTabBarAppearance() {
        tabBar.tintColor = AppColor.primary.color
        tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.95)

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.gray.cgColor

        tabBar.layer.addSublayer(topBorder)
    }
}
