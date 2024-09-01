//
//  TabBarController.swift
//  Geeks
//
//  Created by Alexey Lim on 30/8/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        viewControllers = [UINavigationController(rootViewController: homeVC), UINavigationController(rootViewController: favoritesVC)]
    }
}
