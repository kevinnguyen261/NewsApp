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
        viewModel
            .onNextDetail
            .subscribe(
                onNext: { [weak self] news in
                    self?.pushDetailNews(news)
                }
            ).disposed(by: disposeBag)
        navigationController.removeShadow()
        navigationController.pushViewController(newsViewController, animated: false)
    }
    
    private func pushDetailNews(_ news: News) {
        let newsDetailViewController: NewsDetailViewController = NewsDetailViewController.create()
        let viewModel = NewsDetailViewModel()
        viewModel
            .onNextDetail
            .subscribe(
                onNext: { [weak self] url in
                    self?.pushDetailImage(url)
                }
            ).disposed(by: disposeBag)
        newsDetailViewController.config(viewModel: viewModel)
        newsDetailViewController.news = news
        navigationController.pushViewController(newsDetailViewController, animated: true)
    }
    
    private func pushDetailImage(_ url: String) {
        let detailImageViewController = DetailImageViewController(nibName: "DetailImageViewController", bundle: Bundle(for: DetailImageViewController.self))
        detailImageViewController.imageUrl = url
        detailImageViewController.modalPresentationStyle = .fullScreen
        navigationController.present(detailImageViewController, animated: true)
    }
}
