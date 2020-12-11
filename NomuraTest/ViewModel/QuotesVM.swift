//
//  QuotesVM.swift
//  NomuraTest
//
//  Created by Saugata Chakraborty on 22/11/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import Foundation
import UIKit
class QuotesVM: NomuraViewModel {
    let dataManager = QuotesDM()
    var model: QuotesModel? {
        didSet {
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    func getQuotesList() {
        dataManager.getQuotesList(success: { [weak self](data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(QuotesModel.self, from: data)
                self?.model = item
            } catch {
                self?.delegate?.viewModelUpdateFailed(error: NomuraAppServerResponseError.JsonParsing)
            }
        }, failure: { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
        })
    }
}
