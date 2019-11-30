import KituraContracts
import LoggerAPI
import Foundation
import SwiftKuery


func initializeAttributeRoutes(app: App) {
    app.router.post("/attributes", handler: app.insertAttributeHandler)
    app.router.get("/attributes", handler: app.selectAttributeHandler)
}

extension App {

       // Create table instance here
    
    static let attributeTable = AttributeTable()
    
    func insertAttributeHandler(attribute: Attribute, completion: @escaping (Attribute?, RequestError?) -> Void) {
        // Handle POST here
        let rows = [[attribute.id, attribute.fid, attribute.uid, attribute.name, attribute.price]]
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            // Write query and execute it here
            let insertQuery = Insert(into: App.attributeTable, rows: rows)
            connection.execute(query: insertQuery) { insertResult in
                guard insertResult.success else {
                    Log.error("Error executing query: \(insertResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                completion(attribute, nil)
            }
        }
    }

    func selectAttributeHandler(completion: @escaping ([DisplayAttribute]?, RequestError?) -> Void) {
        App.pool.getConnection() { connection, error in
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            let selectQuery = Select(from: App.attributeTable)
            connection.execute(query: selectQuery) { selectResult in
                guard let resultSet = selectResult.asResultSet else {
                    Log.error("Error connecting: \(selectResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                
                var attributes = [DisplayAttribute]()
                resultSet.forEach() { row, error in
                    guard let row = row else {
                        if let error = error {
                            Log.error("Error getting row: \(error)")
                            return completion(nil, .internalServerError)
                        } else {
                            // All rows have been processed
                            return completion(attributes, nil)
                        }
                    }
                    guard let name = row[3] as? String,
                        let price = row[4] as? Double

                    else {
                        Log.error("Unable to decode product")
                        return completion(nil, .internalServerError)
                    }
                    attributes.append(DisplayAttribute(name: name, price: price))
                }
            }
        }
    }
}
