//
//  User.swift
//  App
//
//  Created by Alex Young on 3/20/20.
//

import Foundation
import FluentMySQL
import Vapor

final class User: MySQLModel {
  var id: Int?
  var username: String
  init(id: Int? = nil, username: String) {
    self.id = id
    self.username = username
  }
    
    func nameFilter(user: User, comparator: String) -> Bool {
        
        return user.username == "Alex"
    }
    
}
extension User: Content {}
extension User: Migration {}

