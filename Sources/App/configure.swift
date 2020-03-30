import Leaf
import Vapor
import FluentMySQL

let host = "ubuntu-01"

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(LeafProvider())
    
    

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    //initiate a database service, add SQLiteDatabase to it and regsister that database service
    //var databases = DatabasesConfig()
   // try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    // services.register(databases)
    
    // configure Fluent MySQL
    
    switch host {
    case "ubuntu-01":
        try services.register(FluentMySQLProvider())
        let mysqlConfig = MySQLDatabaseConfig(
          hostname: "172.104.17.220",
          port: 3306,
          username: "ayoung",
          password: "6uEHZwjKyR22#637",
          database: "ubuntu01"
        )
        services.register(mysqlConfig)
        
    default :
    try services.register(FluentMySQLProvider())
    let mysqlConfig = MySQLDatabaseConfig(
      hostname: "localhost",
      port: 3306,
      username: "root",
      password: "LQJdO3HYiN*X",
      database: "test"
    )
    services.register(mysqlConfig)
        
        
    }
    
    //Initiate and register migration services
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: TeamMember.self, database: .mysql)
    services.register(migrations)
    

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    /// Leaf add tags
    services.register { container -> LeafTagConfig in
        var config = LeafTagConfig.default()
        config.use(Raw(), as: "raw")   // #raw(<myVar>) to print it as raw html in leaf vars
        return config
    }
}
