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
    
    func registerAuthCode(_ req: Request) throws -> ApiCreds {
       
        guard let code = req.query[String.self, at: "code"] else {
            throw Abort(.badRequest)
        }
        
        let  o365User = ApiCreds(
            id: 1,
            name: "o365",
            authCode: code
        )
        
        let didUpdate = o365User.save(on: req)
        //print("Searching for user")
        /*
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
        
       
        return o365User
    }
    
    func updateTokens(_ req: Request, apiUser: Future<ApiCreds>) throws -> Future<ApiCreds> {
          
        let newUser = apiUser.flatMap(to: ApiCreds.self ) { api in
            let code = api.authCode.code
            let o365 = Office365()
            let credentials = o365.accessToken(authCode: code, request: req)
            
            let o365User = ApiCreds(id: 1, name: "o365", authCode: code, accessToken: credentials.accessToken, refreshToken: credentials.refreshToken)
            
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
    
    }
    
    func sendEmailAsync(_ req: Request) throws -> Future<String> {
        
        let o365 = Office365()
        let promise: Promise<String> = req.eventLoop.newPromise()
        
       
        
        let newCredentials = ApiCreds.find(1, on: req).map(to: ApiCreds?.self) { api in
                guard let api = api else {
                    return nil
                }
                let credentials = o365.refreshToken(refreshToken: api.refreshToken, request: req)
                // update the database with a new access token
            api.accessToken.code = credentials.accessToken
                api.refreshToken = credentials.newRefreshToken
                
                let didUpdate = api.update(on: req)
                return api
        }
        
       
          
        /*
        let updatedCredentials = ApiConnection.find(1, on: req).map(to: URLRequest.self) {api in
        
            if let rToken = api?.refreshToken  {
                let credentials = o365.refreshToken(refreshToken: rToken, request: req)
                // update the database with a new access token
                api?.authToken = credentials.authToken
                api?.refreshToken = credentials.newRefreshToken
                let didUpdate = api?.update(on: req)
                let endPoint = o365.sendEmailRequest(refreshToken: credentials.authToken)
                let apiRequest = endPoint.request()
                DispatchQueue.global().async {
                                
                endPoint.responseStringAsync(using: apiRequest) {response in
                promise.succeed(result: response)
                     }
                 }
                
                return apiRequest
                }
            else {
            //return nil
            }
            
        }
            // send the email
            // refresh the access token
            
            

                    
                       
       */
        return promise.futureResult
    
    }
    
    
}
