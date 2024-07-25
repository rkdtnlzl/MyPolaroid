//
//  TabBarViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        
        let main = MainViewController()
        let nav1 = UINavigationController(rootViewController: main)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_trend"), tag: 0)
        
        let search = SearchViewController()
        let nav2 = UINavigationController(rootViewController: search)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_search"), tag: 1)
        
        let favofite = FavoriteViewController()
        let nav3 = UINavigationController(rootViewController: favofite)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_like"), tag: 2)
        
        setViewControllers([nav1,nav2,nav3], animated: true)
    }
}
