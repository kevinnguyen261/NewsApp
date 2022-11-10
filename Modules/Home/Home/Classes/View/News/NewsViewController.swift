//
//  NewsViewController.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit
import RxSwift
import Common
import Base

class NewsViewController: UIViewController {
    @IBOutlet private weak var tableView: ZoomableTableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    private var dispatchWorkItem: DispatchWorkItem?
    private var news: Pagination<News> = .empty()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    private var isLoading = false
    var viewModel: NewsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.addBottomShadow(ofColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                   radius: 3,
                                   offset: CGSize(width: 1, height: 1),
                                   opacity: 1)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.stopZooming()
    }
    
    @objc private func selectCategory() {
        showActionSheet(
            title: "Select category",
            message: "Select the category you want to get headlines for",
            options: NewsCategory.allCases
        ) { [weak self] category in
            self?.viewModel.category = category as? NewsCategory
            self?.initData()
        }
    }
    
    @objc private func searchKeyword() {
        dispatchWorkItem?.cancel()
        if let text = self.textField.text, !text.isEmpty {
            let dispatchWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else {
                    return
                }
                self.emptyView.isHidden = true
                self.tableView.isHidden = false
                self.viewModel.keyword = text
                self.initData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: dispatchWorkItem)
            self.dispatchWorkItem = dispatchWorkItem
        } else {
            self.emptyView.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    @objc private func reloadData() {
        initData()
    }
    
    @objc private func loadmore() {
        isLoading = true
        viewModel
            .loadMore()
            .subscribe(
                onSuccess: { [weak self] news in
                    guard let self = self else {
                        return
                    }
                    self.news.data.append(contentsOf: news.data)
                    self.tableView.reloadData()
                },
                onFailure: { [weak self] error in
                    self?.showAlert(message: error.localizedDescription)
                },
                onDisposed: { [weak self] in
                    self?.isLoading = false
                })
            .disposed(by: disposeBag)
    }
    
    func collapseHeader() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.headerHeightConstraint.constant = 0
                self.headerView.alpha = 0
                self.view.layoutIfNeeded()
            }
        )
    }
    
    func expandHeader() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.headerHeightConstraint.constant = 66
                self.headerView.alpha = 1
                self.view.layoutIfNeeded()
            }
        )
    }
}

extension NewsViewController: BaseViewController {
    func setupViews() {
        title = "Headline News"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(selectCategory))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        tableView.register(NewsTableViewCell.self)
        tableView.refreshControl = refreshControl
        
        textField.addTarget(self, action: #selector(searchKeyword), for: .editingChanged)
        textField.delegate = self
        
        emptyLabel.font = AppStyle.shared.font.regular(size: 16)
        emptyLabel.text = "Insert keyword to search headline news"
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.textColor = .lightGray
    }
    
    func initData() {
        isLoading = true
        news = .empty()
        tableView.reloadData()
        refreshControl.beginRefreshing()
        
        viewModel
            .requestData()
            .subscribe(
                onSuccess: { [weak self] news in
                    guard let self = self else {
                        return
                    }
                    self.news = news
                    self.tableView.reloadData()
                },
                onFailure: { [weak self] error in
                    self?.showAlert(message: error.localizedDescription)
                },
                onDisposed: { [weak self] in
                    UIView.animate(
                        withDuration: 1,
                        animations: {
                            self?.refreshControl.endRefreshing()
                        },
                        completion: nil
                    )
                    self?.isLoading = false
                })
            .disposed(by: disposeBag)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = news.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(NewsTableViewCell.self, for: indexPath)
        cell.setData(news)
        cell
            .onExpand
            .subscribe(onNext: { [weak self] _ in
                self?.news.data[indexPath.row].isExpand = true
                tableView.performBatchUpdates {
                    cell.expandContentLabel()
                }
            })
            .disposed(by: disposeBag)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = news.data[indexPath.row]
        viewModel.onNextDetail.onNext(news)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoading, news.canLoadmore, scrollView.contentOffset.y + scrollView.bounds.size.height + 200 > scrollView.contentSize.height {
            loadmore()
        }
        
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        if velocity.y < (UIDevice.current.orientation.isLandscape ? 0 : -2000) {
            view.endEditing(true)
            collapseHeader()
        } else if velocity.y > 0 {
            expandHeader()
        }
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            URL(string: news.data[safe: $0.row]?.urlToImage ?? "")
        }
        _ = viewModel.preloadUrls(urls)
    }
}

extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
