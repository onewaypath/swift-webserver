import Leaf
import Vapor
import FluentMySQL
import MySQL

let host = "ubuntu-01"

/*
/// Creates connections to an identified MySQL database.
public final class MySQLDatabase2: Database {
    /// This database's configuration.
    public let config: MySQLDatabaseConfig

    /// Creates a new `MySQLDatabase`.
    public init(config: MySQLDatabaseConfig) {
        self.config = config
    }

    /// See `Database`
    public func newConnection(on worker: Worker) -> Future<MySQLConnection> {
        return MySQLConnection.connect(config: self.config, on: worker)
    }
}*/

extension DatabaseIdentifier {
    /// Default identifier for `MySQLDatabase`.
    public static var mysql2: DatabaseIdentifier<MySQLDatabase> {
        return .init("mysql2")
    }
}



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
    
    //config.prefer(LeafRenderer.self, for: PlaintextRenderer.self)
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
    
    
    let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
               hostname: "172.104.17.220",
               port: 3306,
               username: "ayoung",
               password: "6uEHZwjKyR22#637",
               database: "ubuntu01"
               )
       )
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    
    //try services.register(MySQLProvider())
    
    let mysql2 = MySQLDatabase(config: MySQLDatabaseConfig(
            hostname: "97.107.129.88",
            port: 3306,
            username: "ayoung",
            password: "G&h0L6a7%NK86zkK",
            database: "onewaypath_wp"
            )
    )
    //var databases = DatabasesConfig()
    databases.add(database: mysql2, as: .mysql2)
    services.register(databases)
        
    
    
    
    //Initiate and register migration services
    var migrations = MigrationConfig()
    
    //migrations.add(model: Todo.self, database: DatabaseIdentifier<SQLiteDatabase>.sqlite)
    migrations.add(model: User.self, database: DatabaseIdentifier<User.Database>.mysql)
    migrations.add(model: TeamMember.self, database: DatabaseIdentifier<TeamMember.Database>.mysql)
//    migrations.add(model: ApiCreds.self, database: .mysql)
    migrations.add(model: O365.Authenticate.O365ApiCreds.self, database: DatabaseIdentifier<O365.Authenticate.O365ApiCreds.Database>.mysql)
    //migrations.add(model: wp_posts.self, database: .mysql2)

    
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
