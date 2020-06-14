//
//  CreateMessage.swift
//  App
//
//  Created by Alex Young on 5/31/20.
//

import Foundation

extension ActiveCampaign {

    struct createMessage {
    
        struct ApiData: Codable {
            var id : String? = nil
        }
        
        
        var apiData = ApiData()
        var networkRequest: NetworkRequest
        
        init (using: (html: String, text: String), titled: String, distributionStatus: String, author: String) {
            
            let url = "https://buddhavipassana.api-us1.com/admin/api.php"

            let parameters = [
                "api_action":"message_add",
                "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
                "api_output": "json"
            ]
            
            var postData = [
                "fromemail":"info@buddhavipassana.ca",
                "fromname":author,
                "format" : "html",
                "reply2" : "info@buddhavipassana.ca",
                "priority" : "3",
                "encoding" : "quoted-printable",
                "textfetch" : "http://yoursite.com",
                "subject" : titled,
                "textfetchwhen": "send",
                //"p[9]": "9",
                //"p[14]": "14",
                "html": using.html,
                "text": using.text
            ]
            
            switch distributionStatus {
            
            case "live":
                postData["p[3]"] = "3"
                postData["p[4]"] = "4"
            default:
                postData["p[9]"] = "9"
            }

            self.networkRequest = NetworkRequest(url: url, parameters: parameters, postData: postData)
           
        }
        
        mutating func decode(data: Data) {
            
            // decode the JSON response to get the message ID
            //let jsonData = apiResponse.data(using: .utf8)!
            let decoder = JSONDecoder()
            self.apiData = try! decoder.decode(ApiData.self, from: data)
           // print ("Message ID is \(apiData.id)")
        }
        
    }
}
