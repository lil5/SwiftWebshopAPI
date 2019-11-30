//
//  Product.swift
//  
//
//  Created by Josep Jesus on 29/11/2019.
//

import Foundation
import SwiftKuery

class AttributeTable: Table {
    let tableName = "attributes"
    let id = Column("id", Int32.self, primaryKey: true)
    let fid = Column("fid", Int32.self)
    let uid = Column("uid", String.self)
    let name = Column("name", String.self)
    let price = Column("price", Double.self)
}
