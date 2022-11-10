//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import RxSwift
import Base
import Kingfisher
import Common

class NewsViewModel: BaseViewModel {
    var category: NewsCategory?
    var keyword: String?
    private var page: Int = 1
    private var pageSize: Int = 20
    var onNextDetail = PublishSubject<News>()
    
    func requestData() -> Single<Pagination<News>> {
        guard let keyword = keyword else {
            return .just(.empty())
        }
        let request = NewsRequestUseCase.list(page: page, pageSize: pageSize, category: category, keyword: keyword).asRequest()
        return AppManager.shared.network.requestCodable(request: request)
            .map { (response: NewsResponse) in
                return Pagination(data: response.articles, totalData: response.totalResults) 
            }
    }
    
    func loadMore() -> Single<Pagination<News>> {
        guard let keyword = keyword else {
            return .just(.empty())
        }
        page += 1
        let request = NewsRequestUseCase.list(page: page, pageSize: pageSize, category: category, keyword: keyword).asRequest()
        return AppManager.shared.network.requestCodable(request: request)
            .map { (response: NewsResponse) in
                return Pagination(data: response.articles, totalData: response.totalResults) 
            }
    }
    
    func preloadUrls(_ urls: [URL]) -> Single<Void> {
        ImagePrefetcher(resources: urls).start()
        return .just(())
    }
}
