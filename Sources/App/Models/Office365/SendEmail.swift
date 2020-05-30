//
//  SendEmail.swift
//  App
//
//  Created by Alex Young on 5/29/20.
//
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension O365 {
    
    struct sendEmail {
        
        struct Address: Codable {
            var address = "rahyoung@gmail.com"
        }
        
        struct EmailAddress: Codable {
            var emailAddress = Address()
        }
        
        
        struct MessageBody: Codable {
            var contentType = "HTML"
            var content: String
            
            init(content: String) {
                self.content = content
            }
        }
        
        struct Message: Codable {
            var subject = "Meet for Lunch?"
            var body : MessageBody
            var toRecipients = [EmailAddress()]
            var ccRecipients = [EmailAddress()]
            
            init(content: String) {
                self.body = MessageBody(content: content)
            }
            
            
        }
        
        var networkRequest: NetworkRequest
        
        init(accessToken: String, content: String)  {
        
            let url = "https://graph.microsoft.com/beta/me/sendMail"
            
            
            // prepare the body as json string
            
            struct Payload: Codable {
                var message : Message
                var SaveToSentItems: Bool = true
                
                init(content: String) {
                    self.message = Message(content: content)
                }
                
            }
            
            let payload = Payload(content: content)
            let jsonData = try! JSONEncoder().encode(payload)
            // let jsonString = String(data: jsonData, encoding: .utf8)!
            
            
            let parameters:  [String:String] = [:]
               
            let headers = [
                "Authorization" : "Bearer \(accessToken)",
                "Content-Type" : "application/json",
                
            ]
            
            let postData = [
                   "json": "json"
               ]
            print (postData)
            self.networkRequest = NetworkRequest(url: url, parameters: parameters, headers: headers, postData: postData, jsonBody: jsonData)
    
        }
        
    }
    
    
}
