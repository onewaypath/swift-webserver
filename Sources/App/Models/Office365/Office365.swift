//
//  Office365.swift
//  App
//
//  Created by Alex Young on 5/21/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

final class Office365 {

    func accessToken(authCode: String, request: Request) -> (authToken: String, refreshToken: String) {
        
        let url = "https://login.microsoftonline.com/common/oauth2/token"

       
        let parameters:  [String:String] = [:]
        
        let postData = [
            "grant_type":"authorization_code",
            "client_id":"ac8ec0e2-9ecf-47e9-b0bc-fbb072227fc1",
            "redirect_uri" : "https://onewaypath.com/api/office365/register",
            "client_secret" : ".zVHv77s7wFLeHR8qCsVdn.~nf_p8_jkZ0",
            "code" : authCode
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        print(apiResponse)
        
        struct ApiData: Codable {
            var access_token: String
            var refresh_token: String
        }
        
        let jsonData = apiResponse.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let apiData = try! decoder.decode(ApiData.self, from: jsonData)
        
        let o365User = ApiConnection(id: 1, name: "o365", authCode: authCode, authToken: apiData.access_token, refreshToken: apiData.refresh_token)
        
        let didUpdate = o365User.update(on: request)
        return (authToken: apiData.access_token, refreshToken: apiData.refresh_token)
        
    }


   
    
    
}
