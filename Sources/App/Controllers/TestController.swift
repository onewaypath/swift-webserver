//
//  Test.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
import Vapor
import unixTools

final class TestController {

    func async(_ req: Request) throws -> Future<String> {
        
        let promise: Promise<String> = req.eventLoop.newPromise()

        DispatchQueue.global().async {
            let activeCampaign = ActiveCampaign()
            promise.succeed(result: activeCampaign.reviewLists())
        }

        return promise.futureResult
        
    }
    
    
    func office365(_ req: Request) throws -> Future<ApiCreds> {
       
        guard let code = req.query[String.self, at: "code"] else {
            throw Abort(.badRequest)
        }
        
        let  o365User = ApiCreds(
            id: 1,
            name: "o365",
            authCode: code
        )
        
        // o365User.delete(on: req)
        let didUpdate = o365User.update(on: req)
        
        /*
        let name = futureApi.map(to: String.self) { api in
            return api.name
        }*/
        
        return didUpdate
    }
    
    
}
