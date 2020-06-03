//
//  TeamMemberController.swift
//  App
//
//  Created by Alex Young on 3/21/20.
//

import Foundation
import Vapor
import unixTools
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

final class TeamController {
    
    func list(_ req: Request) throws -> Future<View> {
        return TeamMember.query(on: req).all().flatMap { teamMembers in
            
            let data = ["teamList": teamMembers]
            return try req.view().render("teamview", data)
        }
    }
    
    func select(_ req: Request, username:String) throws -> Future<View> {
        return TeamMember.query(on: req).all().flatMap { teamMembers in
            
            var data: [String: String] = [:]
            let bioTemplate = unixTools().runUnix("cat", arguments: ["Public/team/bioTemplate.html"])
            
            let footerText = bioTemplate.slice(from: "<footer", to: "</footer>")
            let footer = "<footer\(footerText ?? "not found")</footer>"

            let scriptText = bioTemplate.slice(from: "<script", to: "</body>")
            let script = "<script\(scriptText ?? "not found")"
            
            let headText = bioTemplate.slice(from: "<head>", to: "</head>")
            let head = "<head>\(headText ?? "not found")</head>"
            
            let navText = bioTemplate.slice(from: "<nav>", to: "</nav>")
            let nav = "<nav>\(navText ?? "not found")</nav>"
            
            for teamMember in teamMembers {
                if teamMember.username == username {
                    data["username"] = teamMember.username
                    data["firstname"] = teamMember.firstname
                    data["lastname"] = teamMember.lastname
                    data["position"] = teamMember.position
                    data["bio"] = unixTools().runUnix("cat", arguments: ["Public/team/\(teamMember.username).htm"])
                    data["footer"] = footer
                    data["script"] = script
                    data["head"] = head
                    data["nav"] = nav
                }
            }
            return try req.view().render("teamSelectView", data)
        }
    }
    
    func create(_ req: Request) throws -> Future<Response> {
      return try req.content.decode(TeamMember.self).flatMap { teamMember in
        return teamMember.save(on: req).map { _ in
          return req.redirect(to: "all")
        }
      }
    }
}
