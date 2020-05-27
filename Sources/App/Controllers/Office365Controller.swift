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
    
    func registerAuthCode(_ req: Request) throws -> Future<ApiCreds> {
       
        let code = req.query[String.self, at: "code"] ?? nil
        
        if code != nil {
            let  o365User = ApiCreds(
                id: 1,
                name: "o365",
                authCode: code!
            )
            
            var didUpdate = o365User.create(on: req)
            didUpdate = try updateRefreshToken(req) // get the new refresh token
            didUpdate = try updateRefreshToken(req) // get the the authorization code
            return didUpdate
        }
        else {
            return try updateRefreshToken(req)
        }
        /*
        guard let code = req.query[String.self, at: "code"] else {
            throw Abort(.badRequest)
        }
        
        let  o365User = ApiCreds(
            id: 1,
            name: "o365",
            authCode: code
        )
        
        let didUpdate = o365User.create(on: req)
        
       
        //print("Searching for user")
    
        let newUser = ApiConnection.find(1, on: req).flatMap(to: ApiConnection.self) {api in
            if api?.id ?? 0 == 0 {
                print ("user could not be found, creating a new one")
                let didCreate = o365User.save(on: req)
                return try self.updateTokens(req, apiUser: didCreate)
            }
            else {
                 
                let didUpdate = o365User.save(on: req)
                return try self.updateTokens(req, apiUser: didUpdate)
            }
            
        }*/
        
    }
    
    func updateRefreshToken(_ req: Request) throws -> Future<ApiCreds> {
         
        //updates both the access token and the refresh token based on the current authorization code
        
        // get the existing authorization code
        let newUser = ApiCreds.find(1, on: req).flatMap(to: ApiCreds.self) { api in
            
            var grantType : O365.UpdateRefreshToken.GrantType
            
            var code: String?
            code = req.query[String.self, at: "code"] ?? nil
            
            /*
            guard let code = api?.authCode.code else {
                throw Abort(.badRequest)
            }*/
            
            
            if code == nil {
                grantType = .refreshToken
                code = api?.refreshToken ?? nil
            }
            else {grantType = .authorizationCode}
           

             
            // TODO: check expiry of authorization code and request a new one if required
            
            /*
            let o365 = Office365()
            let credentials = o365.accessToken(authCode: code, request: req)
            */
            
            let apiCall = O365.UpdateRefreshToken(grantType: grantType, code: code!)
            
            let o365User = ApiCreds(id: 1, name: "o365", authCode: code!, accessToken: apiCall.apiData.access_token ?? "", refreshToken: apiCall.apiData.refresh_token ?? "")
            
            let didUpdate = o365User.update(on: req)
            return didUpdate
        }
        
        
           return newUser
       }
    
    
    
    
    
    /*
    func sendEmail(_ req: Request) throws -> Future<String> {
        
        let semaphore = DispatchSemaphore (value: 0)
        let apiResponse = ApiConnection.find(1, on: req).map(to: String.self) {api in
           
                // refresh the access token
                let o365 = Office365()
                let credentials = o365.refreshToken(refreshToken: api!.refreshToken, request: req)
                
                // update the database
                api?.authToken = credentials.authToken
                api?.refreshToken = credentials.newRefreshToken
                let didUpdate = api?.update(on: req)
            
                // send the email
                var responseString = ""
                responseString = o365.sendEmail(refreshToken: api!.authToken)

            
                                
                
                semaphore.signal()
                return responseString
                
                }
        
        // let string = apiResponse
        // semaphore.wait()
        
        return apiResponse
    
    }
    */
    
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
        
    
    
    /*
    func sendEmail(_ req: Request) throws -> Future<String> {
        
       
        let apiResponse = ApiCreds.find(1, on: req).map(to: String.self) {api in
           
                // get updated tokens from the o365 API
                let o365 = Office365()
                let credentials = o365.refreshToken(refreshToken: api!.refreshToken, request: req)
                
                // update the database
                api?.accessToken.code = credentials.accessToken
                api?.refreshToken = credentials.newRefreshToken
                let didUpdate = api?.update(on: req)
            
                // send the email
                
            let responseString = o365.sendEmail(refreshToken: api!.accessToken.code)
                //print (responseString)
            return responseString
                
                }
        
       
        
        return apiResponse
    
    } */
    
    func sendEmail2(_ req: Request) throws -> Future<String> {
            
            let o365 = Office365()
            
            
                let apiResponse = try self.updateAccessToken(req).flatMap(to: String.self) { api in
            
                let token =  api.accessToken.code
                //let response = o365.sendEmail(refreshToken: token)
                let endpoint = o365.sendEmailRequest(refreshToken: token)
                let apiRequest = endpoint.request()
                //var apiResponse = ""
                
                // hit the API to send the email
                    
                let promise: Promise<String> = req.eventLoop.newPromise()
                DispatchQueue.global().async {
                    endpoint.responseStringAsync(using: apiRequest) { data, response, error in
                        if error != nil {
                            promise.succeed(result: String(describing: error))
                        }
                        else {
                            promise.succeed(result: String(describing: response))
                        }
                    }
                }
                return promise.futureResult // the result will be the respose from the API
            }
            return apiResponse
        
    }
    
    

}
