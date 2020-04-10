import Vapor
import unixTools


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let  bookingSearch = BookingSearch()
    let owpgmainHtml = unixTools().runUnix("cat", arguments: ["Public/index.html"])

    router.get { req in
          return try req.view().render("main-template", ["html": owpgmainHtml])
    }
  
    
    // render the view for any html page that is identified
    router.get("home", String.parameter) { req -> Future<View> in
            let htmlFile = try req.parameters.next(String.self)
            let htmlFilePath = "Public/\(htmlFile)"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
            return try req.view().render("main-template", ["html": html])
    }
    
    // get route at the url users fetching all users from the database and passing them into a view
    
    let userController = UserController()
    router.get("users", use: userController.list)
    
    // post route so that on form submission the input-field data form-url-encoded will be sent to the /users route as a post
    router.post("users", use: userController.create)
    
    
    // *** Team Members ***
    
    // get route at the url team members fetching all members from the database and passing them into a view
    
    let teamController = TeamController()
    
    router.get("team", String.parameter) { req -> Future<View> in
        let user = try req.parameters.next(String.self)
        return try teamController.select(req, username: user)
    }
    
    router.get("team", "all",  use: teamController.list)
    // post route so that on form submission the input-field data form-url-encoded will be sent to the team members route as a post
    router.post("team","submit", use: teamController.create)
   
    // test route for API calls
    router.get("api") { req in
     
      return (bookingSearch.test())
    }
    
}

