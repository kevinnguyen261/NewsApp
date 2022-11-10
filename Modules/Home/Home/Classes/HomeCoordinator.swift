//
//  HomeCoordinator.swift
//  Home
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit
import RxSwift
import Base

public class HomeCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    var disposeBag = DisposeBag()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let newsViewController: NewsViewController = NewsViewController.create()
        let viewModel = NewsViewModel()
        newsViewController.config(viewModel: viewModel)
        navigationController.removeShadow()
        navigationController.pushViewController(newsViewController, animated: false)
    }
}
