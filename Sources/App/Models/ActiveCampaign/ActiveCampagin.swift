//
//  CreateMessage.swift
//  App
//
//  Created by Alex Young on 5/18/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

struct ActiveCampaign {
    
}

final class OldActiveCampaign {

    func createMessage(using: (html: String, text: String), titled: String) -> String {
        let url = "https://buddhavipassana.api-us1.com/admin/api.php"

        let parameters = [
            "api_action":"message_add",
            "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
            "api_output": "json"
        ]

        
        
        let postData = [
            "fromemail":"info@buddhavipassana.ca",
            "fromname":"Buddhavipassana Meditation Centre",
            "format" : "mime",
            "reply2" : "info@buddhavipassana.ca",
            "priority" : "3",
            "encoding" : "quoted-printable",
            "textfetch" : "http://yoursite.com",
            "subject" : titled,
            "textfetchwhen": "send",
            "p[9]":"9",
            "html": using.html,
            "text": using.text
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        print (apiResponse)
        
        
        // decode the JSON response to get the message ID
        
        struct ApiData: Codable {
            var id : String
        }
        
        let jsonData = apiResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        let apiData = try! decoder.decode(ApiData.self, from: jsonData)
        print ("Message ID is \(apiData.id)")
        return (apiData.id)
    }


    func createCampaign(messageID: String, messageName: String, sdate: String) {

        let url = "https://buddhavipassana.api-us1.com/admin/api.php"

        let parameters = [
            "api_action":"campaign_create",
            "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
            "api_output": "json"
        ]

        let postData = [
            "type":"single",
            "name" : messageName,
            "sdate" : sdate,
            "status" : "1",
            "public" : "1",
            "p[9]" : "9",
            "m[\(messageID)]" : "100"
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        print (apiResponse)

    }
    
    func reviewLists() -> String {

        let url = "https://buddhavipassana.api-us1.com/admin/api.php"

        let parameters = [
            "api_action":"list_list",
            "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
            "api_output": "json",
            "ids" : "all"
        ]

        let endpoint = Api(url: url, parameters: parameters)
        let apiRequest = endpoint.request()
    
        var apiResponse = ""
        
        endpoint.responseStringAsync(using: apiRequest) { (data, response, error ) -> () in
           
            apiResponse = String(data: data!, encoding: .utf8)!
            
        }
        return apiResponse
    }
    
    
}
