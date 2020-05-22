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
       
        let didUpdate = o365User.update(on: req)
        
        return didUpdate
    }
    
    func authCode(_ req: Request) throws -> String {
          
        
        let apiUser = ApiConnection.find(1, on: req)
        var apiName = ""
        let authCode = apiUser.map(to: String.self ) { api in
            apiName = api!.authCode
            return apiName
        }
        
        
           return apiName
       }
       
    
    
}
