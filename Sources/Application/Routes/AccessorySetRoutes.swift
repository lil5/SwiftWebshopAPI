import KituraContracts
import LoggerAPI
import Foundation
import SwiftKuery

func initializeAccessorySetRoutes(app: App) {
    app.router.post("/sets", handler: app.insertSetHandler)
    app.router.get("/sets", handler: app.selectSetHandler)
}

extension App {
    // Create connection pool and initialize BookTable here
    


       // Create table instance here
    
    static let accessorySetTable = AccessorySetTable()
    
    func insertSetHandler(accessorySet: AccessorySet, completion: @escaping (AccessorySet?, RequestError?) -> Void) {
        // Handle POST here
        let rows = [[accessorySet.id, accessorySet.fid, accessorySet.uid, accessorySet.name, accessorySet.price]]
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            // Write query and execute it here
            let insertQuery = Insert(into: App.accessorySetTable, rows: rows)
            connection.execute(query: insertQuery) { insertResult in
                guard insertResult.success else {
                    Log.error("Error executing query: \(insertResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                completion(accessorySet, nil)
            }
        }
    }

    func selectSetHandler(completion: @escaping ([DisplayAccessorySet]?, RequestError?) -> Void) {
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
                
                var accessorySets = [DisplayAccessorySet]()
                resultSet.forEach() { row, error in
                    guard let row = row else {
                        if let error = error {
                            Log.error("Error getting row: \(error)")
                            return completion(nil, .internalServerError)
                        } else {
                            // All rows have been processed
                            return completion(accessorySets, nil)
                        }
                    }
                    guard let name = row[3] as? String,
                        let price = row[4] as? Double

                    else {
                        Log.error("Unable to decode product")
                        return completion(nil, .internalServerError)
                    }
                    accessorySets.append(DisplayAccessorySet(name: name, price: price))
                }
            }
        }
    }
}
