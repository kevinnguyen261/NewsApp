//
//  AppDelegate.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let viewController = UIViewController()
        viewController.view.backgroundColor = .yellow
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

