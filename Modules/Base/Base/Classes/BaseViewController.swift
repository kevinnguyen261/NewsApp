//
//  BaseViewController.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit

public protocol BaseViewController: UIViewController {
    associatedtype T: BaseViewModel
    var viewModel: T! { get set }
    func config(viewModel: T)
    func setupViews()
    func initData()
}

public extension BaseViewController {
    static func create<T: UIViewController>() -> T {
        return T(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
    }
    
    func config(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupViews() {}
    
    func initData() {}
}
