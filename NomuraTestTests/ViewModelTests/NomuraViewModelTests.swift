//
//  NomuraViewModelTests.swift
//  NomuraTestTests
//
//  Created by Saugata Chakraborty on 11/12/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import NomuraTest

class NomuraViewModelTests: XCTestCase {
    var promise: XCTestExpectation?
    var expectedError: String?
    var errorFile: String?
    override func setUp() {}
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        errorFile = nil
        expectedError = nil
    }
    func matcher(request: URLRequest) -> Bool {
        if ProcessInfo.processInfo.environment["Mock-API"] == "false" {
            return false
        }
        return request.url?.host == APIConstants.baseURL.replacingOccurrences(of: "https:", with: "").replacingOccurrences(of: "/", with: "")
    }
    func provider(request: URLRequest) -> HTTPStubsResponse {
        var fileName = ""
        if let requestPath = request.url?.path, let name = requestPath.components(separatedBy: "/").last {
            fileName = "\(name).json"
        }
        let stubPath = OHPathForFile(fileName, type(of: self))
        return fixture(filePath: stubPath!, headers: ["Content-Type": APIConstants.contentType, "X-RapidAPI-Key": "928a360a00msh5f86e72a11c7b4cp10af77jsn7455eedbb8d8", "X-RapidAPI-Host": APIConstants.baseURL])
    }
    func errorProvider(request: URLRequest) -> HTTPStubsResponse {
        guard var fileName = errorFile else {
            fatalError()
        }
        fileName = "\(fileName).json"
        let stubPath = OHPathForFile(fileName, type(of: self))
        return fixture(filePath: stubPath!, headers: ["Content-Type": APIConstants.contentType, "X-RapidAPI-Key": "928a360a00msh5f86e72a11c7b4cp10af77jsn7455eedbb8d8", "X-RapidAPI-Host": APIConstants.baseURL])
    }
}
class StepViewModelTest: NomuraViewModelTests {
    var step: String?
    override func tearDown() {
        super.tearDown()
        step = nil
    }
    func stepProvider(request: URLRequest) -> HTTPStubsResponse {
        var fileName = ""
        if let requestPath = request.url?.path, let name = requestPath.components(separatedBy: "/").last, let stepName = step {
            fileName = "\(name)_\(stepName).json"
        }
        let stubPath = OHPathForFile(fileName, type(of: self))
        return fixture(filePath: stubPath!, headers: ["Content-Type": APIConstants.contentType])
    }
}
