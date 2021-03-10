//
//  TeamMember.swift
//  App
//
//  Created by Alex Young on 3/20/20.
//

import Foundation
import FluentMySQL
import Vapor

final class TeamMember: MySQLModel {
    var id: Int?
    var username: String
    var firstname: String
    var lastname: String
    var position: String
    var bio: String
    var company:String
    var category:String

    
    init(id: Int? = nil, username: String, firstname: String, lastname: String, position: String, bio: String, company: String, category: String) {
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.position = position
        self.bio = bio
        self.company = company
        self.category = category
    }
}
extension TeamMember: Content {}
extension TeamMember: Migration {}
