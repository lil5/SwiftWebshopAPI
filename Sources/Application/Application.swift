import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraOpenAPI
import Dispatch
import KituraCORS
import SwiftKuery
import SwiftKueryPostgreSQL

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()
let options = Options(
                      methods: ["GET","PUT", "OPTIONS"],
                      allowedHeaders: ["Content-Type"],
                      maxAge: 5)

let cors = CORS(options: options)

public class App {
    static let poolOptions = ConnectionPoolOptions(initialCapacity: 1, maxCapacity: 5)
    
    static let pool = PostgreSQLConnection.createPool(
        host: "localhost",
        port: 54320,
        options: [
            .databaseName("mydb"),
            .userName("kitura"),
            .password("password")
        ],
        poolOptions: poolOptions
    )
    
    let workerQueue = DispatchQueue(label: "worker")
    let router = Router()
    
    let cloudEnv = CloudEnv()

    public init() throws {
        // Configure logging
        router.all("/", middleware: cors)
        
        initializeLogging()
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // ORM
        initializeORMRoutes(app: self)
        // Endpoints
        initializeHealthRoutes(app: self)
        initializeProductRoutes(app: self)
        initializeAccessorySetRoutes(app: self)
        initializeAttributeRoutes(app: self)
        initializeCartRoutes(app: self)
        KituraOpenAPI.addEndpoints(to: router)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
    
    func execute(_ block: (() -> Void)) {
        workerQueue.sync {
            block()
        }
    }
}
