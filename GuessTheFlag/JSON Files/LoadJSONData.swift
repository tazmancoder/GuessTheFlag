//
//  LoadJSONData.swift
//  GuessTheFlag
//
//  Created by Mark Perryman on 5/16/22.
//

import Foundation

class LoadJSONData: ObservableObject {
    @Published var countryCodes = [CountryCodesJSON]()
    @Published var stateCodes = [StateCodesJSON]()

    init() {
        countryCodes = Bundle.main.decode(from: "CountryCodesData.json")
        stateCodes = Bundle.main.decode(from: "StateCodesData.json")
    }
}
