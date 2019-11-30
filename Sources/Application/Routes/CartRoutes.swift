import KituraContracts
import LoggerAPI
import Foundation
import SwiftKuery


func initializeCartRoutes(app: App) {
    app.router.post("/carts", handler: app.insertAttributeHandler)
    app.router.get("/carts", handler: app.selectAttributeHandler)
}

extension App {

       // Create table instance here
    
    static let cartTable = CartTable()
    
    func insertCartHandler(cart: Cart, completion: @escaping (Cart?, RequestError?) -> Void) {
        // Handle POST here
        let rows = [[cart.id, cart.fid, cart.uid, cart.name, cart.price]]
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            // Write query and execute it here
            let insertQuery = Insert(into: App.cartTable, rows: rows)
            connection.execute(query: insertQuery) { insertResult in
                guard insertResult.success else {
                    Log.error("Error executing query: \(insertResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                completion(cart, nil)
            }
        }
    }

    func selectCartHandler(completion: @escaping ([DisplayCart]?, RequestError?) -> Void) {
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            let selectQuery = Select(from: App.cartTable)
            connection.execute(query: selectQuery) { selectResult in
                guard let resultSet = selectResult.asResultSet else {
                    Log.error("Error connecting: \(selectResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                
                var carts = [DisplayCart]()
                resultSet.forEach() { row, error in
                    guard let row = row else {
                        if let error = error {
                            Log.error("Error getting row: \(error)")
                            return completion(nil, .internalServerError)
                        } else {
                            // All rows have been processed
                            return completion(carts, nil)
                        }
                    }
                    guard let name = row[3] as? String,
                        let price = row[4] as? Double

                    else {
                        Log.error("Unable to decode product")
                        return completion(nil, .internalServerError)
                    }
                    carts.append(DisplayCart(name: name, price: price))
                }
            }
        }
    }
}
