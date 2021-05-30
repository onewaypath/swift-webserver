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
        
        /*
        var runtime: String;
        struct CSS: Content {
               var URL: String?
           }
        
        let css = try req.query.decode(CSS.self)
       */
        
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
    
    
    func displayTeamSelect(req: Request) throws -> Future<View> {
          let page = "team" //try? req.parameters.next(String.self)
          let username = try? req.parameters.next(String.self)
        
          let webpage = getPage(runtimeState: "dev", pageName:page)
          
          return TeamMember.query(on: req).all().flatMap { teamMembers in
              struct PageData: Content {
                  var style: String
                  var header: String
                  var footer: String
                  var teamList: [TeamMember]
                  var targetUsername:  String
              }
              let pageData = PageData(style:webpage.data["style"] ?? "no style", header: webpage.data["header"] ?? "no header", footer:webpage.data["footer"] ?? "no footer", teamList: teamMembers, targetUsername: username!)
              return try req.view().render("teamSelect", pageData)
              //return try req.view().render("team", data)
          }
       
      }
    
    
    func team(_ req: Request) throws -> Future<View> {
        return TeamMember.query(on: req).all().flatMap { teamMembers in
            
            let data = ["teamList": teamMembers]
            return try req.view().render("team", data)
        }
    }
    
    
    func buddhavipassana(req: Request) throws -> Future<View> {
          let page = "buddhavipassana" //try? req.parameters.next(String.self)
          let pageName = try? req.parameters.next(String.self)
        
          let webpage = getPage(runtimeState: "dev", pageName:page)
          
          struct PageData: Content {
                var style: String
                var header: String
                var footer: String
                var html: String
            }
        let pageHTML = unixTools().runUnix("cat", arguments: ["html-dev/buddhavipassana/\(pageName ?? "courses").html"])
        
        let pageData = PageData(style:webpage.data["style"] ?? "no style", header: webpage.data["header"] ?? "no header", footer:webpage.data["footer"] ?? "no footer", html: pageHTML)
              return try req.view().render("buddhavipassana", pageData)
              //return try req.view().render("team", data)
          
       
      }
    
    func onNum(req: Request) throws -> Future<View> {
          let page = "on-num" //try? req.parameters.next(String.self)
          let pageName = try? req.parameters.next(String.self)
        
          let webpage = getPage(runtimeState: "dev", pageName:page)
          
          struct PageData: Content {
                var style: String
                var header: String
                var footer: String
                var html: String
            }
        let pageHTML = unixTools().runUnix("cat", arguments: ["html-dev/on-num/\(pageName ?? "courses").html"])
        
        let pageData = PageData(style:webpage.data["style"] ?? "no style", header: webpage.data["header"] ?? "no header", footer:webpage.data["footer"] ?? "no footer", html: pageHTML)
              return try req.view().render("on-num", pageData)
              //return try req.view().render("team", data)
          
       
      }
    
    
    func atisundara(req: Request) throws -> Future<View> {
        let page = "atisundara" //try? req.parameters.next(String.self)
        //let pageName = try? req.parameters.next(String.self)
      
        let webpage = getPage(runtimeState: "dev", pageName:page)
        
        struct PageData: Content {
              var style: String
              var header: String
              var footer: String
              var html: String
          }
      //let pageHTML = unixTools().runUnix("cat", arguments: ["html-dev/atisundara/\(pageName ?? "index").html"])
      
      let pageHTML = unixTools().runUnix("cat", arguments: ["html-dev/atisundara/index.html"])

      let pageData = PageData(style:webpage.data["style"] ?? "no style", header: webpage.data["header"] ?? "no header", footer:webpage.data["footer"] ?? "no footer", html: pageHTML)
            return try req.view().render("atisundara", pageData)
            //return try req.view().render("team", data)
        
     
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
            //add master CSS
            var cssURL = "https://raw.githubusercontent.com/onewaypath/css/dev/main/master.css"
            style = getCSS(draftURL:cssURL)
            
            //add page specific CSS
            var cssFile = pageName ?? "main" // the default css file has the same name as the page name
            if pageName == "meditation" {cssFile = "main"} // assign the meditation page to the main css
            cssURL = "https://raw.githubusercontent.com/onewaypath/css/dev/main/\(cssFile).css"
            style += getCSS(draftURL:cssURL)
            
        default:
            //add master CSS
            var cssPath: String
            cssPath = "../onewaypath.com-css/main/master.css"
            style = unixTools().runUnix("cat", arguments: [cssPath])
            
            //add page specific CSS
            var cssFile = pageName ?? "main" // the default css file has the same name as the page name
            if pageName == "meditation" {cssFile = "main"} // assign the meditation page to the main css
            cssPath = "../onewaypath.com-css/main/\(cssFile).css"
            style += unixTools().runUnix("cat", arguments: [cssPath])
        }
        data = ["style":style]
        
        // DEFINE THE HTML CONTENT TO ADD TO THE TEMPLATE
        
        let htmlElements = ["header":"header", "html": pageName ?? "index"]
        //var html = ""
        for (key, value) in htmlElements {
            //html += unixTools().runUnix("cat", arguments: ["html-dev/\(element).html"])
            switch key {
            case "html":
                if pageName != "team" { // omit the HTML element for pages that run exclusively from leaf templates
                    data[key] = unixTools().runUnix("cat", arguments: ["html-dev/\(value).html"])
                }
            default:
                data[key] = unixTools().runUnix("cat", arguments: ["html-dev/\(value).html"])
            }
        }
       
        
        
        
    }
    
    
        
}


