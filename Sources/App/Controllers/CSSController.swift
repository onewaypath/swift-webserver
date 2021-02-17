//
//  CSSController.swift
//  App
//
//  Created by Alex Young on 2/15/21.
//

import Foundation
//import Vapor
//#if canImport(FoundationNetworking)
//import FoundationNetworking
//#endif

public struct WebPageController {

    var template :String
    var html: String
    var css: String
    
    init() {
        self.template = "dev-template"
        self.html = "test"
        self.css = "test"
    }
    
    func devSubmissions() -> String {
    
        
        return "dummy"
    
    }

}

// source css
// source html
// construct html

// SOURCE CSS



/*
public struct page {
        
    public struct css {
        var sourceURL: String
    }
    
    public struct html {
        var URLStri
    }
    

   func getCSS() -> String {
    if let url = URL(string: self.URLString) {
           do {
               let contents = try String(contentsOf: url)
               //print(contents)
               return contents
           } catch {
               return "no CSS"
           }
       } else {
           return "no CSS"
       }
   }

}

*/


    


/*
struct CSSController (cssURL:String) { req -> Future<View> in
    
    
    func getCSS(folder: String) -> String {
        if let url = URL(string: "https://raw.githubusercontent.com/onewaypath/css/master/\(folder)/style.css") {
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
    
    
    router.get("dev", String.parameter) { req -> Future<View> in
            let username = try req.parameters.next(String.self)
            let htmlFile = "index"
            let htmlFilePath = "html-dev/\(htmlFile).html"
            let html = unixTools().runUnix("cat", arguments: [htmlFilePath])
        let style = getCSS(folder:username)
        return try req.view().render("dev-template", ["html": html, "style": style])
    }
    
}
*/
