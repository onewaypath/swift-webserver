//
//  ListLists.swift
//  App
//
//  Created by Alex Young on 5/31/20.
//

import Foundation

extension ActiveCampaign {
    
    struct ReviewLists {

        var networkRequest: NetworkRequest
        
        init() {
        
            let url = "https://buddhavipassana.api-us1.com/admin/api.php"

            let parameters = [
                "api_action":"list_list",
                "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
                "api_output": "json",
                "ids" : "all"
            ]

            self.networkRequest = NetworkRequest(url: url, parameters: parameters)
        }
        
    }
    
}
