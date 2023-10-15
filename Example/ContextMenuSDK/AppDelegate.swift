//
//  AppDelegate.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 08/08/2023.
//  Copyright (c) 2023 Aleksandr Lis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let firstController = FirstViewController()
        firstController.tabBarItem = UITabBarItem(title: "first", image:  UIImage(named: "1"), tag: 1)
        
        let secondController = SecondViewController()
        secondController.tabBarItem = UITabBarItem(title: "second", image:  UIImage(named: "2"), tag: 2)
        secondController.tabBarItem.badgeValue = "2"
        
        let thirdController = ThirdViewController()
        thirdController.tabBarItem = UITabBarItem(title: "third", image:  UIImage(named: "3"), tag: 3)
        thirdController.tabBarItem.badgeValue = "3"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: firstController),
            UINavigationController(rootViewController: secondController),
            UINavigationController(rootViewController: thirdController)
        ]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

