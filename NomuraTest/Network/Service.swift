//
//  SerVices.swift
//  NomuraTest
//
//  Created by Saugata Chakraborty on 22/11/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import Alamofire

struct APIConstants {
    static let baseURL = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/"
    static let contentType = "application/json; charset=utf-8"
    static let keyValue = "928a360a00msh5f86e72a11c7b4cp10af77jsn7455eedbb8d8"
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

public class APIRouter: APIConfiguration {
    var method: HTTPMethod {
        return .post
    }
    var path: String {
        return ""
    }
    var parameters: Parameters?
    init(_ params: Parameters? = nil ) {
        parameters = params
    }
    public func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL.init(string: APIConstants.baseURL+path)!)
        request.setValue(APIConstants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(APIConstants.keyValue, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(APIConstants.baseURL.replacingOccurrences(of:"https://" , with: ""), forHTTPHeaderField: "X-RapidAPI-Host")
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        if method.rawValue == HTTPMethod.get.rawValue {
            return try URLEncoding.queryString.encode(request, with: parameters)
        } else {
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
}

class NomuraAppService: NSObject {
    static func request(_ request: URLRequestConvertible, success:@escaping (Data) -> Void, failure:@escaping (NomuraAppError) -> Void) {
        AF.request(request).responseData { (responseObject) -> Void in
            if let data = responseObject.data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(QuotesModel.self, from: data), item.quoteResponse.result.count == 0 {
                    let error = NomuraAppServiceError.init(errorCode: NomuraAppServiceError.ErrorCode.unknownError)
                    failure(error)
                } else {
                    success(data)
                }
            } else {
                var item: NomuraAppError
                if let error = responseObject.error as NSError? {
                    item = NomuraAppServiceError.init(error: error)
                } else {
                    item = NomuraAppServiceError.init(errorCode: NomuraAppServiceError.ErrorCode.unknownError)
                }
                failure(item)
            }
        }
    }
}
