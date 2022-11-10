//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit
import Base
import Home

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private var homeCoordinator: HomeCoordinator?
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        let navigationController = UINavigationController()
        self.homeCoordinator = HomeCoordinator(navigationController: navigationController)
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController = self.navigationController
        homeCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
