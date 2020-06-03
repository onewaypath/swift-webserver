//
//  ActiveCampaignController.swift
//  App
//
//  Created by Alex Young on 6/2/20.
//

import Foundation
import Vapor
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ActiveCampaignController {
    
    func reviewLists( req: Request) throws -> Future<String> {
      
          let apiCall = ActiveCampaign.ReviewLists()
          let promise: Promise<String> = req.eventLoop.newPromise()
                      DispatchQueue.global().async {
                         apiCall.networkRequest.execute(using: apiCall.networkRequest.request()) { data, response, error in
                              if error != nil {
                                  promise.succeed(result: "error")
                              }
                              else {
                                  
                                  let responseString = String(data: data!, encoding: .utf8)
                                  promise.succeed(result: responseString!)
                              }
                          }
                      }
          return promise.futureResult // the result will be the respose from the API
      }
    
    func createMessage( req: Request, content: String? = nil, subject: String? = nil, sdate: String, distributionStatus: String) throws -> Future<String> {
       
           
           let content = content ?? "Test Content" // unixTools().runUnix("cat", arguments: ["Public/emailTemplate2.html"]
           let subject = subject ?? "Test Message"
           
           var responseString = ""
        var apiCall = ActiveCampaign.createMessage(using: (html: content, text: "TEXT"), titled: subject, distributionStatus: distributionStatus)
           
           //get the message ID and save the message response in the response string
           
           let messageResponseID: Promise<String> = req.eventLoop.newPromise()
                       DispatchQueue.global().async {
                          apiCall.networkRequest.execute(using: apiCall.networkRequest.request()) { data, response, error in
                               if error != nil {
                                   messageResponseID.succeed(result: "error")
                               }
                               else {
                                   
                                   responseString.append(String(data: data!, encoding: .utf8)!)
                                   apiCall.decode(data: data!)
                                   let messageID = apiCall.apiData.id ?? "Error: the ID could not be decoded"
                                   
                                   //responseString.append("\r \r The message ID is \(messageID) ")
                                   messageResponseID.succeed(result: messageID)
                                   
                               }
                           }
                       }
           
           // use the messageID to hit the CreateCampagin API
           
           let combinedResponse = messageResponseID.futureResult.flatMap(to: String.self) { messageID in
               
            let combinedResponse = self.createCampaign(req: req, messageID: messageID, sdate: sdate, messageName: subject, distributionStatus: distributionStatus).map(to: String.self) { response in
                   
                   // format the combined reponse for JSON ouput
                   return "{\"messageResponse\": \(responseString), \"campaignResponse\":\(response)}"
                   
               }
               
               return combinedResponse
           }
           
           // send a confirmation email with the the same content
           //let o365 = Office365Controller()
           //try o365.sendEmail(req, content: content, subject: subject)
           
           return combinedResponse
       }
       
    func createCampaign( req: Request, messageID: String, sdate: String, messageName: String, distributionStatus: String) -> Future<String> {
       
        let apiCall = ActiveCampaign.createCampaign(messageID: messageID, messageName: messageName, sdate: sdate, distributionStatus: distributionStatus)
           
           let promise: Promise<String> = req.eventLoop.newPromise()
                       DispatchQueue.global().async {
                          apiCall.networkRequest.execute(using: apiCall.networkRequest.request()) { data, response, error in
                               if error != nil {
                                   promise.succeed(result: "error")
                               }
                               else {
                                   
                                   let responseString = String(data: data!, encoding: .utf8)
                                   promise.succeed(result: responseString!)
                               }
                           }
                       }
           return promise.futureResult // the result will be the respose from the API
       }
}
