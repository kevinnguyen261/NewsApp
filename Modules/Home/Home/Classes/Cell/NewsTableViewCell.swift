//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit
import Kingfisher
import Nantes
import RxSwift
import Base
import Common

class NewsTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: NantesLabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var zoomView: ZoomableView!
    @IBOutlet private var seperatorViews: [UIView]!
    
    var onExpand = PublishSubject<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        titleLabel.font = AppStyle.shared.font.medium(size: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.textColor = Color.inkBlack
        
        contentLabel.font = AppStyle.shared.font.regular(size: 12)
        contentLabel.textColor = Color.cyanBlue
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 2
        contentLabel.setDefaultTruncate(font: AppStyle.shared.font.regular(size: 12))
        contentLabel.labelTappedBlock = { [weak self] in
            self?.onExpand.onNext(())
        }
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = Color.gray90
        
        seperatorViews.forEach({ $0.backgroundColor = Color.gray90 })
        
        zoomView.isZoomable = true
        zoomView.sourceView = mainImageView
    }
    
    func setData(_ news: News) {
        if let title = news.title, !title.isEmpty {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let content = news.content, !content.isEmpty {
            contentLabel.text = content
            contentLabel.isHidden = false
            contentLabel.numberOfLines = news.getNumberOfLines()
        } else {
            contentLabel.isHidden = true
        }
        
        mainImageView.kf.setImage(
            with: URL(string: news.urlToImage ?? "")
        )
    }
    
    func expandContentLabel() {
        contentLabel.numberOfLines = 0
    }
}

extension NewsTableViewCell: ZoomableTableViewCell {
    var zoomableView: ZoomableView {
        return zoomView
    }
}
