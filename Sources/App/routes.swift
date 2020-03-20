import Vapor
import unixTools


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    /*let edgehill3Html = unixTools().runUnix("cat", arguments: ["Public/edgehill-3.html"])
      let bioayoungHtml = unixTools().runUnix("cat", arguments: ["Public/bio-ayoung.html"])
      let biomyoungHtml = unixTools().runUnix("cat", arguments: ["Public/bio-myoung.html"])
      let bioibsantosHtml = unixTools().runUnix("cat", arguments: ["Public/bio-ibsantos.html"])
      let biomatgimeHtml = unixTools().runUnix("cat", arguments: ["Public/bio-matgime.html"])
     */
    let owpgmainHtml = unixTools().runUnix("cat", arguments: ["Public/index.html"])
    /*
      router.get("subscribe") { req -> Future<View> in
          
          let filters = try req.query.decode(UsersFilters.self)
          
          let firstName = filters.firstName
          let lastName = filters.lastName
          let email = filters.email
          
          var tester = activeCampaignApi()
          tester.test()
          tester.addContact(firstName: firstName, lastName: lastName, emailAddress: email) { code, ID in
              tester.apiResponse = true
              tester.resultCode = code!
              tester.subscriberID = ID!
              
          }
          
          while tester.apiResponse == false {
              
          }
          
          let data = ["subscriberID": tester.subscriberID]
          return try req.view().render("subscribe", data)
          //return "user id #\(tester.subscriberID), First Name #\(firstName), Last Name #\(lastName), Email #\(email)"
      }
      */
     
      
      router.get { req in
          return try req.view().render("main-template", ["html": owpgmainHtml])
      }
      
    
    
    // html routes
    
    // render the view for the site index (where no page is identified)
    /*
    let siteIndex = unixTools().runUnix("cat", arguments: ["Public/index.html"])
    
    router.get { req in
        return try req.view().render("main-template", ["html": siteIndex])
    }*/
    
    /*
    let html = unixTools().runUnix("cat", arguments: ["Public/index.html"])
    
      
      router.get { req in
        return "hello"
        // return try req.view().render("main-template", ["html": html])
      }
    */
    
    // render the view for any html page that is identified
    router.get("owpg",String.parameter) { req -> Future<View> in
        
        
           
            let htmlFile = try req.parameters.next(String.self)
            let htmlFilePath = "Public/owpg/\(htmlFile)"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
            return try req.view().render("main-template", ["html": html])
    
        //catch {
        //    return try req.view().render("main-template", ["html": html])
        // }
        
        
    }
}

