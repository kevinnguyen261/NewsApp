//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation
import Base
import RxSwift

class NewsDetailViewModel: BaseViewModel {
    var onNextDetail = PublishSubject<String>()
}
