import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // "It works" page
    router.get { req in
        return try req.view().render("welcome")
    }
    
    router.get ("funding", "01") { req in
        return try req.view().render("funding-01")
    }
    
    router.get ("funding", "02") { req in
        return try req.view().render("funding-02")
    }
    
    router.get ("incorporation", "01") { req in
        return try req.view().render("incorporation-01")
    }
    
    router.get ("incorporation", "02") { req in
        return try req.view().render("incorporation-02")
    }
    
    // Says hello
    router.get("hello", String.parameter) { req -> Future<View> in
        return try req.view().render("hello", [
            "name": req.parameters.next(String.self)
        ])
    }
}
