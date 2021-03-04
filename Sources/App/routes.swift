import Vapor
import unixTools
import HTTP


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // *** ROUTES TO DISPLAY HOME PAGES ***
    
    let owpgmainHtml = unixTools().runUnix("cat", arguments: ["Public/index.html"])

    /*router.get { req in
          return try req.view().render("main-template", ["html": owpgmainHtml])
    }*/
    
    router.get("cimages", String.parameter) { req -> Future<Response> in
           //let root = unixTools().runUnix("pwd")
        let file = try req.parameters.next(String.self)
            
           return try req.streamFile(at: "Public/images/\(file)").encode(for: req).map { response in
                response.http.headers.add(name: .cacheControl, value: "max-age=60")
                return response
           }
     

       }
    
    /*
   let homesHtml = unixTools().runUnix("cat", arguments: ["Public/homes.html"])
   router.get("homes") { req -> Future<View> in
    return try req.view().render("main-template", ["html": homesHtml])
   }*/
   /*
    let meditationHtml = unixTools().runUnix("cat", arguments: ["Public/meditation.html"])
    router.get("meditation") { req -> Future<View> in
     return try req.view().render("main-template", ["html": meditationHtml])
    }*/
    
    // *** ROUTES TO DISPLAY TEAM MEMBER PAGES ***
    
    // get route at the url team members fetching all members from the database and passing them into a view
    
    let teamController = TeamController()
    /*
    router.get("team", String.parameter) { req -> Future<View> in
        let user = try req.parameters.next(String.self)
        return try teamController.select(req, username: user)
    }*/
    
    /*
    router.get("team", "all",  use: teamController.list)
    // post route so that on form submission the input-field data form-url-encoded will be sent to the team members route as a post
    router.post("team","submit", use: teamController.create)
    */
    
    // *** ROUTES TO TEST HTML TEMPLATES
    
    /* render the view for any html page that is identified
    router.get("home", String.parameter) { req -> Future<View> in
            let htmlFile = try req.parameters.next(String.self)
            let htmlFilePath = "Public/\(htmlFile)"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
            return try req.view().render("main-template", ["html": html])
    }*/
    
    
     // *** ROUTES TO TEST HTML DEV TEMPLATES
    // render the view for any html page that is identified
    /*
    
    router.get("dev", String.parameter) { req -> Future<View> in
            let htmlFile = try req.parameters.next(String.self)
        let htmlFilePath = "html-dev/\(htmlFile).html"
            let styleFilePath = "Public/dev/htmlFile/css/style.css"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
            let style = unixTools().runUnix("cat", arguments: [styleFilePath])
        return try req.view().render("dev-template", ["html": html, "style": style])
    }*/
    
    
    //ROUTES TO TEST NEW CSS
    
    func getCSS(draftURL: String) -> String {
        if let url = URL(string: draftURL) {
            do {
                let contents = try String(contentsOf: url)
                //print(contents)
                return contents
            } catch {
                return "no-css"
            }
        } else {
            return "no-css"
        }
    }
    
    let webPage = WebPageController()
    router.get() { req -> Future<View> in return try webPage.displayPage(req:req) }
    router.get(String.parameter, use: webPage.displayPage)
    router.get("teamSelect", String.parameter, use: webPage.displayTeamSelect)
    
    
    
    
   
    struct CSS: Content {
        var URL: String?
    }
    
    router.get("draft") { req -> Future<View> in
        
        let htmlFile = "index"
        let htmlFilePath = "html-dev/\(htmlFile).html"
        let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
        let css = try req.query.decode(CSS.self)
        let style = getCSS(draftURL:css.URL!)
        // return style
        return try req.view().render("dev-template", ["html": html, "style": style])
    }
    
   
    /*    router.get("param") { req -> String in
        
        let css = try req.query.decode(CSS.self)
        return (css.URL!)
    }*/
    
    /*
    router.get("raw", "css", String.parameter) { req -> String in
           //let root = unixTools().runUnix("pwd")
        let username = try req.parameters.next(String.self)
        let rawCSS = unixTools().runUnix("cat", arguments: ["../onewaypath.com-css/\(username)/style.css"])
           return rawCSS
       }
    */
    // *** ROUTES TO TEST USER MANAGEMENT (Retained for future development)
    
    // get route at the url users fetching all users from the database and passing them into a view
    
    let userController = UserController()
    router.get("users", "list", use: userController.list)
     router.get("users", "update", use: userController.update)
    
    // post route so that on form submission the input-field data form-url-encoded will be sent to the /users route as a post
    router.post("users", use: userController.create)
    
    
    // *** ROUTES TO TEST API CALLS ***
    
    let checkFrontController = CheckfrontConroller()
    //router.get("api", "checkfront", "availability", use: checkFrontController.availabilityAsync)
    router.get("api", "checkfront", "availability", use: checkFrontController.availability)
    
    let covid19ChartsController = Covid19ChartsController()
    router.get("covid19", String.parameter , use: covid19ChartsController.view)
    
    // ACTIVECAMPAIGN REQUESTS
    let activeCampaignController = ActiveCampaignController()
    //router.get("newsletter", "test", use: newsletterController.test)
    router.get("newsletter", "reviewLists", use: activeCampaignController.reviewLists)
    
    
    // *** NEWSLETTER POST REQUEST
    
    let newsletterController = NewsletterController()
   
    //router.get("newsletter", "createMessage", use: newsletterController.createMessage)
    //router.get("newsletter", "createCampaign", use: newsletterController.createCampaign)
    router.post("newsletter", use: newsletterController.post)
    router.get("newsletter", use: newsletterController.get)
    //router.get("newsletter", use: newsletterController.post)
    
    // ROUTE FOR KLAUS MULTI-PARKING REDIRECT
   
    
    router.get("parking") { req in
        return req.redirect(to: "https://www.youtube.com/watch?v=lDbMnNMdFFg")
    }
    // *** OFFICE 365 ROUTES
/*
    let testController = TestController()
    router.get("test", "async", use: testController.async)
//    router.get("test", "office365", use: testController.office365)
*/
    let office365Controller = Office365Controller()
    router.get("api", "office365", use: office365Controller.registerAuthCode)
    router.get("api", "office365", "requestTokens", use: office365Controller.requestTokens)
    //router.get("api", "office365", "sendEmail", use: office365Controller.sendEmail)
    //router.get("api", "office365", "updateAccessToken", use: office365Controller.updateAccessToken)
    
    router.get("api", "office365", "sendEmail") { req -> Future<String> in
        return try office365Controller.sendEmail(req, content: "Test Content", subject: "Test Subject")
    }
    
    router.get("wordpress") { req in
        return wp_posts.query(on: req).all()
    }
    
    // SAMPLE ROUTE FOR HOW TO RETURN A DATABASE QUERY
    
    router.get("sql") { req in
        return req.withPooledConnection(to: .mysql2) { conn in
            return conn.raw("SELECT ID, post_date, post_content, post_title FROM onewaypath_wp.wp_posts WHERE post_type = 'post' AND post_status = 'publish'")
                .all(decoding: wp_posts.self)
        }.map { rows in
            return rows
        }
    }
    
    // SAMPLE ROUTE FOR HOW TO RETURN A DATABASE QUERY
    
    router.get("sql2") { req in
        return req.withPooledConnection(to: .mysql2) { conn in
            return conn.raw("SELECT ID, post_date, post_title FROM onewaypath_wp.wp_posts WHERE post_type = 'post' AND post_status = 'publish'")
                .all(decoding: wp_posts.self)
        }.map { rows in
            
            return rows
        }
    }
    
    let wordpress = WordPressController()
    router.get("owpg", "blog", use: wordpress.owpPosts)
    
    /*
    struct MySQLVersion: Codable {
        let version: String
    }

    router.get("sql") { req in
        return req.withPooledConnection(to: .mysql2) { conn in
            return conn.raw("SELECT @@version as version")
                .all(decoding: MySQLVersion.self)
        }.map { rows in
            return rows[0].version
        }
    }
    
    
    router.get("sql2") { req in
        return req.withPooledConnection(to: .mysql2) { conn in
            
           // let users = conn.select().all().from(User.self).where(\User.name == "Vapor").all(decoding: User.self)
            
            return conn.raw("SELECT * FROM User")
                .all(decoding: User.self)
        }.map { rows in
            return rows[0].username
        }
    }
    
    
    router.get("sql3") { req -> Future<String> in
              
        let queryResult = req.withPooledConnection(to: .mysql2) { conn in
                   
                  // let users = conn.select().all().from(User.self).where(\User.name == "Vapor").all(decoding: User.self)
                   
                   return conn.raw("SELECT * FROM User")
                       .all(decoding: User.self)
               }.map { rows in
                   return rows[0].username
               }
        
        
              return queryResult
      }
   
    */
}

