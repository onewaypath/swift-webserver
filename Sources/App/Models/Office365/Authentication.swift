//
//  Office365Model.swift
//  App
//
//  Created by Alex Young on 5/26/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import FluentMySQL
import Vapor

struct O365 {
    
    struct Authenticate {
    
        
        enum GrantType {
            case authorizationCode
            case refreshToken
        }
        
        struct O365ApiCreds: Codable, MySQLModel {
            
            var id: Int?
            var code: String?
            var access_token: String?
            var refresh_token : String?
            var expires_in:  String?
            var date: Date?
            
            init(id: Int? = nil, code: String? = nil, access_token: String? = nil, refresh_token: String? = nil, expires_in: String? = nil, date: Date? = Date()) {
                
                self.id = id
                self.code = code
                self.access_token = access_token
                self.refresh_token = refresh_token
                self.expires_in = expires_in
                self.date = date
            }
            
        }
        
        

        //var endpoint: Api
        var networkRequest: NetworkRequest
        
        
        init(grantType: GrantType, code: String)  {
            
            let url = "https://login.microsoftonline.com/common/oauth2/token"
            let parameters:  [String:String] = [:]
            
            var postData = [
                "client_id":"ac8ec0e2-9ecf-47e9-b0bc-fbb072227fc1",
                "redirect_uri" : "https://onewaypath.com/api/office365/register",
                "client_secret" : ".zVHv77s7wFLeHR8qCsVdn.~nf_p8_jkZ0",
            ]
            
            switch grantType {
            case .refreshToken:
                postData["grant_type"] = "refresh_token"
                postData["refresh_token"] = code
            default:
                postData["grant_type"] = "authorization_code"
                postData["code"] = code
            }
            
            //print (postData)
            
            //self.endpoint = Api(url: url, parameters: parameters, postData: postData)
            self.networkRequest = NetworkRequest(url: url, parameters: parameters, postData: postData)

                    }
                }

}

extension O365.Authenticate.O365ApiCreds: Content {}
extension O365.Authenticate.O365ApiCreds: Migration {}
