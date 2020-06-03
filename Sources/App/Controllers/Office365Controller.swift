//
//  Office365Controller.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
import Vapor
import unixTools

final class Office365Controller {
    
    func registerAuthCode(_ req: Request) throws -> Future<O365.Authenticate.O365ApiCreds> {
       
        let code = req.query[String.self, at: "code"] ?? nil
        
         print("creating new user")
            if code != nil {
                let  o365User = O365.Authenticate.O365ApiCreds(
                    id: 1,
                    //name: "o365",
                    code: code!
                    
                )
            
            var didUpdate = o365User.create(on: req)
            print("successfully created new user")
                
            didUpdate = try requestTokens(req) // get the new refresh token
            // didUpdate = try updateRefreshToken(req) // get the the authorization code
            return didUpdate
        }
        else {
            return try requestTokens(req)
        }
        
    }
    
    func requestTokens(_ req: Request) throws ->  Future<O365.Authenticate.O365ApiCreds> {//Future<ApiCreds> {
         
        //updates both the access token and the refresh token based on the current authorization code
        
        // get the existing authorization code
        let newUser = O365.Authenticate.O365ApiCreds.find(1, on: req).flatMap(to: O365.Authenticate.O365ApiCreds.self) { api in
            
            var grantType : O365.Authenticate.GrantType
            
            var code: String?
            code = req.query[String.self, at: "code"] ?? nil
            
            
            if code == nil {
                if api?.isExpired() ?? true {
                    grantType = .refreshToken
                    code = api?.refresh_token ?? nil
                }
                else {
                    let promise: Promise<O365.Authenticate.O365ApiCreds> = req.eventLoop.newPromise()
                    promise.succeed(result: api!)
                    return promise.futureResult}
            }
            else {grantType = .authorizationCode}
           
           
            
        
            
            
           
            let promise: Promise<O365.Authenticate.O365ApiCreds> = req.eventLoop.newPromise()
            DispatchQueue.global().async {
                let apiCall = O365.Authenticate(grantType: grantType, code: code!)
                var apiData = O365.Authenticate.O365ApiCreds()
                apiCall.networkRequest.execute(using: apiCall.networkRequest.request()) { data, response, error in
                    if error != nil {
                        print("The API did not return a valid Access Token")
                    }
                    else {
                        let decoder = JSONDecoder()
                        apiData = try! decoder.decode(O365.Authenticate.O365ApiCreds.self, from: data!)
                        print(String(data: data!, encoding: .utf8)!)
                        promise.succeed(result: apiData)
                        
                    }
                }
                
                
               
            }
            
            let newO365User = promise.futureResult.map(to: O365.Authenticate.O365ApiCreds.self) { call in
                
                let o365User = O365.Authenticate.O365ApiCreds(id: 1, code: code!, access_token: call.access_token ?? "could not decode access token", refresh_token:  call.refresh_token ?? "", expires_in: call.expires_in ?? nil)
                
                return o365User
            }
            
            
            
            let didUpdate = newO365User.update(on: req)
            return didUpdate
        }
        
        
           return newUser
       }
    
    func sendEmail(_ req: Request, content: String, subject: String) throws -> Future<String> {
            
            //let o365 = Office365()
            
            
                let apiResponse = try self.requestTokens(req).flatMap(to: String.self) { api in
            
                let token =  api.access_token
                let htmlEmailContent = content// unixTools().runUnix("cat", arguments: ["Public/emailTemplate2.html"])
                //let subject = "What To Do When We're Overwhelmed"
                let subject = subject// Test Subject"
                    
                    let apiCall = O365.sendEmail(accessToken: token!, content: htmlEmailContent, subject: subject)
                
                // hit the API to send the email
                    
                let promise: Promise<String> = req.eventLoop.newPromise()
                DispatchQueue.global().async {
                    apiCall.networkRequest.execute(using: apiCall.networkRequest.request()) { data, response, error in
                        if error != nil {
                            promise.succeed(result: String(describing: error))
                        }
                        else {
                            let urlResponse = response as! HTTPURLResponse
                            let responseCode = String(urlResponse.statusCode)
                            let responseString = "{\"e-mail status\": \(responseCode)}"
                            //promise.succeed(result: String(describing: response))
                            promise.succeed(result: String(responseString))
                        }
                    }
                }
                return promise.futureResult // the result will be the respose from the API
            }
            return apiResponse
        
    }
    
}
    
    
/*
    
    func updateAccessToken(_ req: Request) throws -> Future<ApiCreds> {
        
       //updates only the access token

       
        let updatedCredentials = ApiCreds.find(1, on: req).flatMap(to: ApiCreds?.self) {api in
               
                // get existing token from the database
                let o365 = Office365()
                
                /*
                guard let currentRefreshToken = api?.refreshToken else {
                    print("there is no existing refresh token")
                    throw Abort(.badRequest)
                }*/
                
                // check the expiry of the existing token
                
                let expiry = api?.accessToken.expiry ?? Date()
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMdd hh:mm:ss")
                let expiryDateString = dateFormatter.string(from: expiry)
                let nowDateString = dateFormatter.string(from: Date())
                print ("The date now is: \(nowDateString)")
                print("The expiry date will be: \(expiryDateString)")
            
                var buffer = DateComponents()
                buffer.second = -10
                let bufferedExpiry = Calendar.current.date(byAdding: buffer, to: expiry) ?? Date()
                let bufferedExpiryString = dateFormatter.string(from: bufferedExpiry)
                print ("The buffered expiry is: \(bufferedExpiryString)")
            
                let promise: Promise<ApiCreds?> = req.eventLoop.newPromise()
                if Date() > bufferedExpiry {
                    print("The access token has expired and will be refreshed")
                    // hit the o365 API to get new credentials
                    
                    DispatchQueue.global().async {
                        
                        struct ApiData: Codable {
                            var access_token: String
                            var refresh_token: String
                            var expires_in: String
                        }
                        
                        let endpoint = o365.updateAccessToken(refreshToken: api!.refreshToken, request: req)
                        let apiRequest = endpoint.request()
                            //print(apiResponse)
                        
                        endpoint.responseStringAsync(using: apiRequest) { data, response, error in
                            if error != nil {
                                print("The API did not return a valid Access Token")
                            }
                            else {
                                let decoder = JSONDecoder()
                                let apiData = try! decoder.decode(ApiData.self, from: data!)
                                
                                var expiryOffset = DateComponents()
                                expiryOffset.second = Int(apiData.expires_in)
                                let expiry = Calendar.current.date(byAdding: expiryOffset, to: Date()) ?? Date()
                                
                                api?.accessToken.code = apiData.access_token
                                api?.accessToken.expiry = expiry
                                api?.refreshToken = apiData.refresh_token
                                print("The new access token is \(String(describing: api?.accessToken.code))")
                            }
                        }
             
                        promise.succeed(result: api) // the result will be the updated credenitals
                    }
                }
                else {
                    promise.succeed(result: api) // the result will be the old credentials
                    print("The access token is still valid")
                }
            return promise.futureResult
        }
        
        // store the updated model in the database
            let didUpdate = updatedCredentials.flatMap(to: ApiCreds.self) { api in
                
                guard let update = api?.update(on: req) else {
                    print("could not update the database")
                    throw Abort(.badRequest)
                }
                return update
            }
          return didUpdate
        }
        
    
    */
    
