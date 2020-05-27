//
//  Office365Model.swift
//  App
//
//  Created by Alex Young on 5/26/20.
//

import Foundation
import Vapor

final class O365 {
    
    final class UpdateRefreshToken: Codable {
    
        
        enum GrantType {
            case authorizationCode
            case refreshToken
        }
        
        struct ApiData: Codable {
        
            var access_token: String? = nil
            var refresh_token : String? = nil
            var expires_in:  String? = nil
        }
        
        var apiData: ApiData
        
        
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
            
            print (postData)
            
            let endpoint = Api(url: url, parameters: parameters, postData: postData)
            let apiRequest = endpoint.request()
            //var apiData: UpdateRefreshToken
            var apiResponse = ApiData()
            
            //print(apiResponse)
            
            //let promise: Promise<Data> = req.eventLoop.newPromise()
            //DispatchQueue.global().async {

                endpoint.responseStringAsync(using: apiRequest) { data, response, error in
                    if error != nil {
                        print("The API did not return a valid Access Token")
                    }
                    else {
                        let decoder = JSONDecoder()
                        apiResponse = try! decoder.decode(UpdateRefreshToken.ApiData.self, from: data!)
                        let apiString = String(data: data!, encoding: .utf8)
                        print (apiString!)
                        /*
                        var expiryOffset = DateComponents()
                        expiryOffset.second = Int(apiData.expires_in)
                        let expiry = Calendar.current.date(byAdding: expiryOffset, to: Date()) ?? Date()
                        */
                    }
                }
            //}
            //let apiResponse = endpoint.responseString(using: apiRequest)
            //print(apiResponse)
            
            //et jsonData = apiResponse.data(using: .utf8)!
            //promise.succeed(result: apiResponse)
            self.apiData = apiResponse
           }
    }
}
