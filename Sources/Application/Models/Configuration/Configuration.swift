//
//  Product.swift
//  
//
//  Created by Josep Jesus on 29/11/2019.
//

import Foundation

struct Configuration: Codable {
    let id: Int32
    let fid: Int32
    let uid: String
    let name: String
    let price: Double

    init(id: Int32, fid: Int32, uid: String, name: String, price: Double) {
        self.id = id
        self.fid = fid
        self.uid = uid
        self.name = name
        self.price = price
    }
}

extension Configuration: Modal {}
