//
//  Product.swift
//  
//
//  Created by Josep Jesus on 29/11/2019.
//

import Foundation

struct DisplayCart: Codable {
    let name: String
    let price: Double

    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
