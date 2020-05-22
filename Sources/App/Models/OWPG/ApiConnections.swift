//
//  ApiCredentials.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
import FluentMySQL
import Vapor

final class ApiConnection: MySQLModel {
    var id: Int?
    var name: String
    var authCode: String
    var authToken: String
    var refreshToken: String
    
    init(id: Int? = nil, name: String, authCode: String = "", authToken: String = "", refreshToken: String = "") {
    self.id = id
    self.name = name
    self.authCode = authCode
    self.authToken = authToken
    self.refreshToken = refreshToken
  }
    
    
    
}
extension ApiConnection: Content {}
extension ApiConnection: Migration {}

