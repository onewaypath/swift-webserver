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
    
    
    
    
    func post(_ req: Request) throws -> Future<HTTPStatus> {
    
         struct MessageRequest: Content {
             var content: String
             var author: String
            var subject: String
         }
         
         return try req.content.decode(MessageRequest.self).map(to: HTTPStatus.self) { messageRequest in
             print("author: \(messageRequest.author)")
             print("content: \(messageRequest.content)")
            print ("subject: \(messageRequest.subject)")
            
          
            let content = unixTools().runUnix("cat", arguments: ["Public/emailContent.txt"])
                
            //let author = "Alex Young" */
            //let content = messageRequest.content
            let author = messageRequest.author
            let subject = messageRequest.subject
            
            // Create the HTML email
            
            let testFile = "Public/postOutput.html"
            let htmlFile = "emailTemplate.html"
            let htmlFilePath = "Public/\(htmlFile)"
            let htmlTemplate = unixTools().runUnix("cat", arguments: [htmlFilePath])
            
            let html1 = htmlTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
            let html = html1.replacingOccurrences(of: "[CONTENT GOES HERE]", with: content)
            
            
            // create the text email
            
            let textFile = "emailTest.html"
            let textFilePath = "Public/\(textFile)"
            let textTemplate = unixTools().runUnix("cat", arguments: [textFilePath])
            
            let text1 = textTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
            let text2 = text1.replacingOccurrences(of: "[CONTENT GOES HERE]", with: content)
            let text = text2.replacingOccurrences(of: "[SUBJECT]", with: subject)
            
            
            // Format the send date
            var range = DateComponents()
            range.day =  1
            let date = Calendar.current.date(byAdding: range, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sendDate = dateFormatter.string(from: date)
            print ("\(sendDate) 00:00:00")

            // Post the message to ActiveCampaign
            
            let activeCampaign = ActiveCampaign()
            let id = activeCampaign.createMessage(using: (html: html, text: text), titled: subject)
            activeCampaign.createCampaign(messageID: id, messageName: subject, sdate: sendDate)
            
            // Save the output to a local test file for debugging
            
            _ = unixTools().runUnix("rm", arguments:["-rf", testFile])
            _ = unixTools().runUnix("touch", commandPath: "/usr/bin/", arguments: [testFile])
            unixTools().runUnixToFile("echo", arguments: [html], filePath: testFile)
            //return try req.view().render("main-template", ["html": html])
            
             return .ok
         }
     }
    
}
