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


public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()
let options = Options(
                      methods: ["GET","PUT", "OPTIONS"],
                      allowedHeaders: ["Content-Type"],
                      maxAge: 5)

let cors = CORS(options: options)

public class App {
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
        // Endpoints
        initializeHealthRoutes(app: self)
        initializeKueryRoutes(app: self)
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
