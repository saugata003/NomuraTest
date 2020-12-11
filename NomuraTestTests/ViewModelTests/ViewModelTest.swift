//
//  ViewModelTest.swift
//  NomuraTestTests
//
//  Created by Saugata Chakraborty on 11/12/20.
//  Copyright © 2020 Azure. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import NomuraTest

class ViewModelTest: NomuraViewModelTests {
    let quotesVM = QuotesVM()
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testGetQuotesList() {
        stub(condition: matcher, response: provider)
        let expect = XCTestExpectation.init(description: "Stock Records")
        promise = expect
        quotesVM.delegate = self
        quotesVM.getQuotesList()
        wait(for: [expect], timeout: 30)
    }
    func testGetQuotesListError() {
        stub(condition: matcher, response: provider)
        let expect = XCTestExpectation.init(description: "Stock Records Error")
        promise = expect
        errorFile = "get-quotesError"
        expectedError = "No records found"
        quotesVM.delegate = self
        quotesVM.getQuotesList()
        wait(for: [expect], timeout: 30)
    }
    func testGetQuotesListJsonError() {
        stub(condition: matcher, response: provider)
        let expect = XCTestExpectation.init(description: "Stock Records Json Error")
        promise = expect
        errorFile = "get-quotesJsonError"
        expectedError = NomuraAppServerResponseError.JsonParsing.localizedMessage
        quotesVM.delegate = self
        quotesVM.getQuotesList()
        wait(for: [expect], timeout: 10)
    }
}

extension ViewModelTest: ViewModelDelegate {
    func viewModelDidUpdate(sender: NomuraViewModel) {
        XCTAssertFalse(quotesVM.model!.quoteResponse.result.isEmpty)
        promise?.fulfill()
    }
    
    func viewModelUpdateFailed(error: NomuraAppError) {
        if let expError = expectedError {
            XCTAssert(error.localizedMessage == expError)
            promise?.fulfill()
        } else {
            XCTFail(error.localizedMessage)
        }
    }
    
    
}
