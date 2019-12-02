//
//  File.swift
//  
//
//  Created by  Lucian Last on 02/12/2019.
//

import Foundation

struct ProductConfigurationLL: Codable {
    let id: Int32
    let productId: Int32
    let configurationId: Int32
}

extension ProductConfigurationLL: Modal {
    public static func getConfigurationsByProductId(productId: Int32) -> [Configuration]? {
        let wait = DispatchSemaphore(value: 0)
        
        var productConfigurationTable: Table
        var configurationTable: Table
        do {
            productConfigurationTable = try ProductConfigurationLL.getTable()
            configurationTable = try Configuration.getTable()
        } catch {
            // catch error
            
        }
        
        // result var
        var listOfConfigurations: [Configuration]? = nil
        // build query
        let query = Select(from: productConfigurationTable)
            .where(productConfigurationTable.id == productId)
            .leftJoin(configurationTable)
            .on(productConfigurationTable.configurationId == configurationTable.id)
        
        // Run query
        ProductConfigurationLL.executeQuery(query: query, parameters: nil) { results, error in
            listOfConfigurations = results
            wait.signal()
            return
        }
        
        wait.wait()
        return listOfConfigurations
    }
}
