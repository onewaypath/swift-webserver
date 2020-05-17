//
//  NewsletterController.swift
//  App
//
//  Created by Alex Young on 5/17/20.
//

import Foundation
import Vapor
import unixTools

final class NewsletterController {
    
    func test(_ req: Request) throws -> Future<View> {
        
        // let content = "This is the email"
        let author = "Alex Young"
        
        let testFile = "Public/getOutput.html"
        let htmlFile = "emailTest.html"
        let htmlFilePath = "Public/\(htmlFile)"
        let htmlTemplate = unixTools().runUnix("cat", arguments: [htmlFilePath])
        
        let html = htmlTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
        _ = unixTools().runUnix("rm", arguments:["-rf", testFile])
        _ = unixTools().runUnix("touch", commandPath: "/usr/bin/", arguments: [testFile])
        unixTools().runUnixToFile("echo", arguments: [html], filePath: testFile)
        return try req.view().render("main-template", ["html": html])
    }
    
    
    func sms(_ req: Request) throws -> Future<HTTPStatus> {
   
        struct MessageRequest: Content {
            var to: String
            var from: String
            var body: String
        }
        
        return try req.content.decode(MessageRequest.self).map(to: HTTPStatus.self) { messageRequest in
            print("To: \(messageRequest.to)")
            print("From: \(messageRequest.from)")
            print("Body: \(messageRequest.body)")
            return .ok
        }
    }
    
    func post(_ req: Request) throws -> Future<HTTPStatus> {
    
         struct MessageRequest: Content {
             var content: String
             var author: String
         }
         
         return try req.content.decode(MessageRequest.self).map(to: HTTPStatus.self) { messageRequest in
             print("author: \(messageRequest.author)")
             print("content: \(messageRequest.content)")
            
            let content = messageRequest.content
            let author = messageRequest.author
            
            let testFile = "Public/postOutput.html"
            let htmlFile = "emailTest.html"
            let htmlFilePath = "Public/\(htmlFile)"
            let htmlTemplate = unixTools().runUnix("cat", arguments: [htmlFilePath])
            
            let html1 = htmlTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
            let html = html1.replacingOccurrences(of: "[CONTENT GOES HERE]", with: content)
            _ = unixTools().runUnix("rm", arguments:["-rf", testFile])
            _ = unixTools().runUnix("touch", commandPath: "/usr/bin/", arguments: [testFile])
            unixTools().runUnixToFile("echo", arguments: [html], filePath: testFile)
            //return try req.view().render("main-template", ["html": html])
            
             return .ok
         }
     }
    
}
