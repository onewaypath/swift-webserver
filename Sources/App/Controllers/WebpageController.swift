//
//  CSSController.swift
//  App
//
//  Created by Alex Young on 2/15/21.
//

import Foundation
import Vapor
import unixTools
//#if canImport(FoundationNetworking)
//import FoundationNetworking
//#endif

struct WebPageController {
    
    func displayPage(req: Request) throws -> Future<View> {
        let page = try? req.parameters.next(String.self)
        //let page = "index"
        let webpage = getPage(runtimeState: "live", pageName:page)
        
        switch page {
        
        case "team" :
            return TeamMember.query(on: req).all().flatMap { teamMembers in
                struct PageData: Content {
                    var style: String
                    var header: String
                    var footer: String
                    var teamList: [TeamMember]
                }
                let pageData = PageData(style:webpage.data["style"] ?? "no style", header: webpage.data["header"] ?? "no header", footer:webpage.data["footer"] ?? "no footer", teamList: teamMembers)
                return try req.view().render(webpage.template, pageData)
                //return try req.view().render("team", data)
            }
        default:  return try req.view().render(webpage.template, webpage.data)
        }
        
     
    }
    
    func team(_ req: Request) throws -> Future<View> {
        return TeamMember.query(on: req).all().flatMap { teamMembers in
            
            let data = ["teamList": teamMembers]
            return try req.view().render("team", data)
        }
    }
    
    
}

struct getPage {

    
    
    var template: String
    //var html: String
    //var style: String
    var data: [String:String]
    //var runtimeState: RuntimeState
       
    
    
    init(runtimeState:String, pageName:String?) {
       
        //var htmlFile: String
        // DEFINE THE WEBPAGE TEMPLATE
        switch pageName {
        case "team" : template = "team"
        default: template = "dev-template"
        
        }
        //DEFINE THE CSS STYLE TO ADD TO THE HTML TEMPLATE
        let username = "main"
        func getCSS(draftURL: String) -> String {
            if let url = URL(string: draftURL) {
                do {
                    let contents = try String(contentsOf: url)
                    //print(contents)
                    return contents
                } catch {
                    return ""
                }
            } else {
                return ""
            }
        }
        
        var style:String
        switch runtimeState {
        case "dev":
            let cssURL = "https://raw.githubusercontent.com/onewaypath/css/master/\(username)/style.css"
            style = getCSS(draftURL:cssURL)
        default:
            var cssPath: String

            cssPath = "../onewaypath.com-css/main/master.css"
            style = unixTools().runUnix("cat", arguments: [cssPath])
            var cssFile = pageName ?? "main" // the default css file has the same name as the page name
            if pageName == "meditation" {cssFile = "main"} // assign the meditation page to the main css
            cssPath = "../onewaypath.com-css/main/\(cssFile).css"
           
            style += unixTools().runUnix("cat", arguments: [cssPath])
        }
        data = ["style":style]
        
        // DEFINE THE HTML CONTENT TO ADD TO THE TEMPLATE
        
        let htmlElements = ["header":"header", "html": pageName ?? "index", "footer": "footer"]
        //var html = ""
        for (key, value) in htmlElements {
            //html += unixTools().runUnix("cat", arguments: ["html-dev/\(element).html"])
            switch key {
            case "html":
                if pageName != "team" { // omit the HTML element for pages that run only from leaf
                    data[key] = unixTools().runUnix("cat", arguments: ["html-dev/\(value).html"])
                }
            default:
                data[key] = unixTools().runUnix("cat", arguments: ["html-dev/\(value).html"])
            }
        }
       
        
        
        
    }
    
    
        
}


