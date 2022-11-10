//
//  HomeCoordinator.swift
//  Home
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit
import Base

public class HomeCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let newsViewController = UIViewController()
        newsViewController.view.backgroundColor = .yellow
        navigationController.pushViewController(newsViewController, animated: false)
    }
}
