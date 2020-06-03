//
//  CreateCampaign.swift
//  App
//
//  Created by Alex Young on 5/31/20.
//

import Foundation

extension ActiveCampaign {
    
    struct createCampaign {
        
        var networkRequest: NetworkRequest
        
        init(messageID: String, messageName: String, sdate: String, distributionStatus: String) {

            let url = "https://buddhavipassana.api-us1.com/admin/api.php"

            let parameters = [
                "api_action":"campaign_create",
                "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
                "api_output": "json"
            ]

            var postData = [
                "type":"single",
                "name" : messageName,
                "sdate" : sdate,
                "status" : "1",
                "public" : "1",
                //"p[9]" : "9",
                //"p[14]" : "14",
                "m[\(messageID)]" : "100"
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
        
        
    }
    
    
}
