//
//  UserController.swift
//  App
//
//  Created by Alex Young on 3/20/20.
//

import Foundation
import Vapor
import FluentMySQL
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class UserController {

    
    func list(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap { users in
            let data = ["userlist": users]
            
            return try req.view().render("userview", data)
        }
    }
    
    
    func update(_ req: Request) throws -> Future<User> {
        
        
        let user = User(id:1, username: "Alex")
        let didUpdate = user.save(on: req)
        print(didUpdate)

        return didUpdate
        
    }
    
    func create(_ req: Request) throws -> Future<Response> {
      return try req.content.decode(User.self).flatMap { user in
        return user.save(on: req).map { _ in
          return req.redirect(to: "users")
        }
      }
    }
}


