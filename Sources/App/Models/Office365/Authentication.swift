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
            
            func isExpired() -> Bool {
                // check the expiry of the existing token
                    
                    
                // determine the expiry date
                var standardExpiry = DateComponents()
                standardExpiry.second = Int(self.expires_in ?? "3600")
                let expiry = Calendar.current.date(byAdding: standardExpiry, to: self.date!) ?? Date()
                
                
                // print the expiry and current dates
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMdd hh:mm:ss")
                let expiryDateString = dateFormatter.string(from: expiry)
                let nowDateString = dateFormatter.string(from: Date())
                print ("The date now is: \(nowDateString)")
                print("The token expiry date is: \(expiryDateString)")
                if Date() > expiry {print("The Token is expired and will be refreshed")}
                else {print("The Token is still valid")}
            
                
                // add a buffer to the expriry date
                var buffer = DateComponents()
                buffer.second = -10
                let bufferedExpiry = Calendar.current.date(byAdding: buffer, to: expiry) ?? Date()
                let bufferedExpiryString = dateFormatter.string(from: bufferedExpiry)
                print ("The buffered token expiry is: \(bufferedExpiryString)")
                if Date() > bufferedExpiry {print("The token is older than the buffered expiry and will be refreshed")}
                else {print("The token is still valid compared to the buffered expiry")}
                
                // compare the buffered expriry date to the current date and return the appropriate result
                
                if Date() > bufferedExpiry {return true}
                else {return false}
                
            }
            
            
        }
        
        

        //var endpoint: Api
        var networkRequest: NetworkRequest
        
        
        init(grantType: GrantType, code: String)  {
            
            let url = "https://login.microsoftonline.com/common/oauth2/token"
            let parameters:  [String:String] = [:]
            
            var postData = [
                "client_id":"ac8ec0e2-9ecf-47e9-b0bc-fbb072227fc1",
                "redirect_uri" : "https://onewaypath.com/api/office365/",
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
