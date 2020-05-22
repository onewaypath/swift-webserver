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
    
    func register(_ req: Request) throws -> Future<ApiConnection> {
       
        guard let code = req.query[String.self, at: "code"] else {
            throw Abort(.badRequest)
        }
        
        let  o365User = ApiConnection(
            id: 1,
            name: "o365",
            authCode: code
        )
        
    
        let newUser = ApiConnection.find(1, on: req).flatMap(to: ApiConnection.self) {api in
            if api?.id ?? 0 == 0 {
                let didCreate = o365User.create(on: req)
                return try self.updateToken(req, apiUser: didCreate)
            }
            else {
                 
                let didUpdate = o365User.update(on: req)
                return try self.updateToken(req, apiUser: didUpdate)
            }
            
        }
        
       
        return newUser
    }
    
    func updateToken(_ req: Request, apiUser: Future<ApiConnection>) throws -> Future<ApiConnection> {
          
        let newUser = apiUser.flatMap(to: ApiConnection.self ) { api in
            let code = api.authCode
            let o365 = Office365()
            let credentials = o365.accessToken(authCode: code, request: req)
            
            let o365User = ApiConnection(id: 1, name: "o365", authCode: code, authToken: credentials.authToken, refreshToken: credentials.refreshToken)
            
            let didUpdate = o365User.update(on: req)
            
            return didUpdate
        }
        
        
           return newUser
       }
       
    
    
}
