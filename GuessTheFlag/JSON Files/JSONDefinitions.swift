//
//  JSONDefinitions.swift
//  GuessTheFlag
//
//  Created by Mark Perryman on 5/16/22.
//

import Foundation

struct CountryCodesJSON: Identifiable, Codable {
    var id: UUID
    var name: String
    var iso2: String
    var iso3: String
}

struct StateCodesJSON: Identifiable, Codable {
    var id: UUID
    var name: String
    var abbreviation: String
}
