//
//  BaseViewController.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit

protocol BaseViewController: UIViewController {
    associatedtype T: BaseViewModel
    var viewModel: T! { get set }
    func config(viewModel: T)
    func setupViews()
    func initData()
}

extension BaseViewController {
    func config(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupViews() {}
    
    func initData() {}
}
