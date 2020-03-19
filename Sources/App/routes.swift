import Vapor
import unixTools


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // html routes
    
    // render the view for the site index (where no page is identified)
    /*
    let siteIndex = unixTools().runUnix("cat", arguments: ["Public/index.html"])
    
    router.get { req in
        return try req.view().render("main-template", ["html": siteIndex])
    }*/
    
    
    let owpgmainHtml = unixTools().runUnix("cat", arguments: ["Public/index.html"])
    
      
      router.get { req in
          return try req.view().render("main-template", ["html": owpgmainHtml])
      }
    
    
    // render the view for any html page that is identified
    router.get(String.parameter) { req -> Future<View> in
        
        do {
            let htmlFile = try req.parameters.next(String.self)
            let htmlFilePath = "Public/\(htmlFile)"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
            return try req.view().render("main-template", ["html": html])
        }
        catch {
            return try req.view().render("main-template", ["html": owpgmainHtml])
        }
        
        
    }
}

