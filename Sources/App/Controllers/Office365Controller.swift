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
                return didCreate
            }
            else {
                 
                let didUpdate = o365User.update(on: req)
                return didUpdate
            }
        }
        return newUser
    }
    
    func token(_ req: Request) throws -> Future<ApiConnection> {
          
        
        let apiUser = ApiConnection.find(1, on: req)
        
        let newUser = apiUser.flatMap(to: ApiConnection.self ) { api in
            let code = api!.authCode
            let o365 = Office365()
            let didUpdate = o365.accessToken(authCode: code, request: req)
            return didUpdate
        }
        
        
           return newUser
       }
       
    
    
}
