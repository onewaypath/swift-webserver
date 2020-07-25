//
//  WordpressModel.swift
//  App
//
//  Created by Alex Young on 6/17/20.
//

import Foundation
import FluentMySQL
import Vapor

struct wp_posts: MySQLModel {
    
    var id: Int?
    var ID: Int
    var post_date: Date
    var post_content: String
    var post_title: String
    
    
    
}
extension wp_posts: Content {}
extension wp_posts: Migration {}
