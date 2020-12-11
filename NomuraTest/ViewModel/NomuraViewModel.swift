//
//  NomuraViewModel.swift
//  NomuraTest
//
//  Created by Saugata Chakraborty on 22/11/20.
//  Copyright © 2020 Saugata Chakraborty. All rights reserved.
//

import Foundation
protocol ViewModelDelegate: class {
    func viewModelDidUpdate(sender: NomuraViewModel)
    func viewModelUpdateFailed(error: NomuraAppError)
}

class NomuraViewModel: NSObject {
    weak var delegate: ViewModelDelegate?
}
