//
//  QuotesDM.swift
//  NomuraTest
//
//  Created by Saugata Chakraborty on 22/11/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import Alamofire
enum ListRoute: String {
    case quotesListUrl = "market/v2/get-quotes?symbols=AMD,IBM,AAPL&region=US"
}

public class ListRouter: APIRouter {
    let route: ListRoute
    override var method: HTTPMethod {
        return .get
    }
    init(_ params: [String: Any]? = nil, route: ListRoute) {
        self.route = route
        super.init(params)
    }
    override var path: String {
        return route.rawValue
    }
}

class QuotesDM: NSObject {
    public func getQuotesList(success: @escaping (Data) -> Void, failure: @escaping(NomuraAppError) -> Void) {
        let router = ListRouter(nil, route: .quotesListUrl)
        NomuraAppService.request(router, success: success, failure: failure)
    }
}
