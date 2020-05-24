//
//  Office365.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

final class Office365 {

    func accessToken(authCode: String, request: Request) -> (accessToken: String, refreshToken: String) {
        
        let url = "https://login.microsoftonline.com/common/oauth2/token"

       
        let parameters:  [String:String] = [:]
        
        let postData = [
            "grant_type":"authorization_code",
            "client_id":"ac8ec0e2-9ecf-47e9-b0bc-fbb072227fc1",
            "redirect_uri" : "https://onewaypath.com/api/office365/register",
            "client_secret" : ".zVHv77s7wFLeHR8qCsVdn.~nf_p8_jkZ0",
            "code" : authCode
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        // print(apiResponse)
        
        struct ApiData: Codable {
            var access_token: String
            var refresh_token: String
        }
        
        let jsonData = apiResponse.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let apiData = try! decoder.decode(ApiData.self, from: jsonData)
        return (accessToken: apiData.access_token, refreshToken: apiData.refresh_token)
        
    }
   
    
    func refreshToken(refreshToken: String, request: Request) -> (accessToken: String, newRefreshToken: String) {
            
            let url = "https://login.microsoftonline.com/common/oauth2/token"

           
            let parameters:  [String:String] = [:]
            
            let postData = [
                "grant_type":"refresh_token",
                "client_id":"ac8ec0e2-9ecf-47e9-b0bc-fbb072227fc1",
                "redirect_uri" : "https://onewaypath.com/api/office365/register",
                "client_secret" : ".zVHv77s7wFLeHR8qCsVdn.~nf_p8_jkZ0",
                "refresh_token" : refreshToken
            ]

            let endpoint = Api(url: url, parameters: parameters, postData: postData)
            let apiRequest = endpoint.request()
            let apiResponse = endpoint.responseString(using: apiRequest)
            //print(apiResponse)
            
            struct ApiData: Codable {
                var access_token: String
                var refresh_token: String
            }
            
            let jsonData = apiResponse.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            let apiData = try! decoder.decode(ApiData.self, from: jsonData)
            return (accessToken: apiData.access_token, newRefreshToken: apiData.refresh_token)
    }
    
    struct Address: Codable {
        var address = "rahyoung@gmail.com"
    }
    
    struct EmailAddress: Codable {
        var emailAddress = Address()
    }
    
    
    struct MessageBody: Codable {
        var contentType = "Text"
        var content = "The New Cafeteria is Open"
    }
    
    struct Message: Codable {
        var subject = "Meet for Lunch?"
        var body = MessageBody()
        var toRecipients = [EmailAddress()]
        var ccRecipients = [EmailAddress()]
        
    }

        
    func sendEmail(refreshToken: String) -> String {
    
        
        
        let url = "https://graph.microsoft.com/beta/me/sendMail"
        
        
        // prepare the body as json string
        
        struct Payload: Codable {
            var message = Message()
            var SaveToSentItems: Bool = true
        }
        let payload = Payload()
        let jsonData = try! JSONEncoder().encode(payload)
        // let jsonString = String(data: jsonData, encoding: .utf8)!
        
        
        let parameters:  [String:String] = [:]
           
        let headers = [
            "Authorization" : "Bearer \(refreshToken)",
            "Content-Type" : "application/json"
            //"Content-Type" : "application/x-www-form-urlencoded"
            
        ]
        
        let postData = [
               "json": "json"
           ]
        //print (postData)
        let endpoint = Api(url: url, parameters: parameters, headers: headers, postData: postData, jsonBody: jsonData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        //print(apiResponse)
        
        return apiResponse
           
    }
    
    func sendEmailRequest(refreshToken: String) -> Api {
    
        
        
        let url = "https://graph.microsoft.com/beta/me/sendMail"
        
        
        // prepare the body as json string
        
        struct Payload: Codable {
            var message = Message()
            var SaveToSentItems: Bool = true
        }
        let payload = Payload()
        let jsonData = try! JSONEncoder().encode(payload)
        // let jsonString = String(data: jsonData, encoding: .utf8)!
        
        
        let parameters:  [String:String] = [:]
           
        let headers = [
            "Authorization" : "Bearer \(refreshToken)",
            "Content-Type" : "application/json",
            
        ]
        
        let postData = [
               "json": "json"
           ]
        print (postData)
        let endPoint = Api(url: url, parameters: parameters, headers: headers, postData: postData, jsonBody: jsonData)
        //let apiRequest = endpoint.request()
        //let apiResponse = endpoint.responseString(using: apiRequest)
        //print(apiResponse)
        
        return endPoint
           
    }
}

   
    
    

