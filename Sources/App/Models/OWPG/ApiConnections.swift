//
//  ApiCredentials.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
import FluentMySQL
import Vapor



final class ApiCreds: MySQLModel {
        
    struct TokenCredential: Codable {
     var code: String
     var expiry: Date
     
     
    }
    
    var id: Int?
    var name: String
    var authCode: TokenCredential
    var accessToken: TokenCredential
    var refreshToken: String
    
    init(id: Int? = nil, name: String, authCode: String = "", accessToken: String = "", refreshToken: String = "") {
    self.id = id
    self.name = name
    self.authCode = TokenCredential(code: authCode, expiry: Date())
    self.accessToken = TokenCredential(code: accessToken, expiry: Date())
    self.refreshToken = refreshToken
  }
    
    
    
}
extension ApiCreds: Content {}
extension ApiCreds: Migration {}

