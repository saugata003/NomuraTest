//
//  Errors.swift
//  NomuraTest
//
//  Created by Saugata Chakraborty on 22/11/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import Foundation
public protocol NomuraAppErrorCode {
    var code: Int {get}
    var domain: String {get}
    var localizedMessage: String {get}
    var localizedTitle: String? {get}
}

open class NomuraAppError: NSError {
    public var errorCode: NomuraAppErrorCode
    open var localizedMessage: String {
        return errorCode.localizedMessage
    }
    open var localizedTitle: String? {
        return errorCode.localizedTitle
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    public init(errorCode: NomuraAppErrorCode) {
        self.errorCode = errorCode
        super.init(domain: errorCode.domain, code: errorCode.code, userInfo: nil)
    }
}

class NomuraAppServiceError: NomuraAppError {
    enum ErrorCode: Int, NomuraAppErrorCode {
        case unknownError
        case connectionError
        case requestTimeOut
        case noNetwork
        var code: Int {
            return rawValue
        }
        var domain: String {
            return "WebService"
        }
        var localizedMessage: String {
            switch self {
            case .unknownError:
                return "Unknown error. Please try again later."
            case .connectionError:
                return "Could not connect to server. Please try again later."
            case .noNetwork:
                return "Not connected to internet. Please check your connection"
            case .requestTimeOut:
                return "Request Timed out"
            }
        }
        var localizedTitle: String? {
            return "Nomura Assignment"
        }
    }
    static func customError(for error: NSError) -> ErrorCode {
        switch error.code {
        case -1009:
            return .noNetwork
        case -1001:
            return .requestTimeOut
        case -1008...(-1002):
            return .connectionError
        default:
            return .unknownError
        }
    }
    public convenience init(error: NSError) {
        let item = NomuraAppServiceError.customError(for: error)
        self.init(errorCode: item)
    }
}

class NomuraAppServerResponseError: NomuraAppError {
    static let JsonParsing = NomuraAppServerResponseError.init(errorCode: ErrorCode.jsonParsingError)
    static let Unknown = NomuraAppServerResponseError.init(errorCode: ErrorCode.unknownError)
    enum ErrorCode: NomuraAppErrorCode {
        case jsonParsingError
        case serverErrorMessage(String)
        case unknownError
        var code: Int {
            return 0
        }
        var domain: String {
            return "ServerResponse"
        }
        var localizedMessage: String {
            switch self {
            case .serverErrorMessage(let message):
                return message
            default:
                return "No Internet Connection Found!!!"
            }
        }
        var localizedTitle: String? {
            return "Nomura Assignment"
        }
    }
    public convenience init(error: String) {
        let item = ErrorCode.serverErrorMessage(error)
        self.init(errorCode: item)
    }
}

class NomuraAppErrorResponse: NomuraAppError {
    struct ErrorCode: NomuraAppErrorCode {
        let serverError: String
        var code: Int {
            return 100
        }
        var domain: String {
            return "APIResponse"
        }
        var localizedMessage: String {
            return "No Internet Connection Found!!!"
        }
        var localizedTitle: String? {
            return "Nomura Assignment"
        }
    }
    public convenience init(error: String) {
        let item = ErrorCode(serverError: error)
        self.init(errorCode: item)
    }
}
