//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit
import Base
import Common
import RxSwift

class NewsDetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    var viewModel: NewsDetailViewModel!
    var news: News!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    @objc func seeDetailImage() {
        viewModel.onNextDetail.onNext(news.urlToImage ?? "")
    }
}

extension NewsDetailViewController: BaseViewController {
    func setupViews() {
        title = "News detail"
        
        titleLabel.font = AppStyle.shared.font.medium(size: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.inkBlack
        titleLabel.text = news.title
        
        contentLabel.font = AppStyle.shared.font.regular(size: 12)
        contentLabel.textColor = Color.cyanBlue
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.text = news.content
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = Color.gray90
        mainImageView.kf.setImage(
            with: URL(string: news.urlToImage ?? "")
        )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeDetailImage))
        mainImageView.addGestureRecognizer(tapGesture)
        mainImageView.isUserInteractionEnabled = true
    }
}
