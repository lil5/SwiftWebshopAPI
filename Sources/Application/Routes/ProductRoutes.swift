import KituraContracts
import LoggerAPI
import Foundation
import SwiftKuery


func initializeProductRoutes(app: App) {
    app.router.post("/products", handler: app.insertProductHandler)
    app.router.get("/products", handler: app.selectProductHandler)
}

extension App {
    
    static let productTable = ProductTable()
    
    func insertProductHandler(product: Product, completion: @escaping (Product?, RequestError?) -> Void) {
        // Handle POST here
        let rows = [[product.id, product.fid, product.uid, product.name, product.price]]
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            // Write query and execute it here
            let insertQuery = Insert(into: App.productTable, rows: rows)
            connection.execute(query: insertQuery) { insertResult in
                guard insertResult.success else {
                    Log.error("Error executing query: \(insertResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                completion(product, nil)
            }
        }
    }

    func selectProductHandler(completion: @escaping ([DisplayProduct]?, RequestError?) -> Void) {
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            let selectQuery = Select(from: App.productTable)
            connection.execute(query: selectQuery) { selectResult in
                guard let resultSet = selectResult.asResultSet else {
                    Log.error("Error connecting: \(selectResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                
                var products = [DisplayProduct]()
                resultSet.forEach() { row, error in
                    guard let row = row else {
                        if let error = error {
                            Log.error("Error getting row: \(error)")
                            return completion(nil, .internalServerError)
                        } else {
                            // All rows have been processed
                            return completion(products, nil)
                        }
                    }
                    guard let name = row[3] as? String,
                        let price = row[4] as? Double

                    else {
                        Log.error("Unable to decode product")
                        return completion(nil, .internalServerError)
                    }
                    products.append(DisplayProduct(name: name, price: price))
                }
            }
        }
    }
}
