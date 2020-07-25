//
//  WordPressController.swift
//  App
//
//  Created by Alex Young on 6/18/20.
//


import Foundation
import Vapor
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct WordPressController {
    
    
    // this function returns an array of wp_posts
    func owpPosts(req: Request) -> Future<[wp_posts]> {
        return req.withPooledConnection(to: .mysql2) { conn in
            return conn.raw("SELECT ID, post_date, post_content, post_title FROM onewaypath_wp.wp_posts WHERE post_type = 'post' AND post_status = 'publish'")
                .all(decoding: wp_posts.self)
        }.map { rows in
            return rows
        }
    }
    
}
