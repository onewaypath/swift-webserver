//
//  CheckfrontController.swift
//  App
//
//  Created by Alex Young on 4/11/20.
//

import Foundation
import Vapor
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class CheckfrontConroller {

   
    
    func availability (_ req: Request) throws -> Future<String> {
                
                        
        let bookingSearch = Checkfront.BookingSearch()
        
                    
                    // hit the API to send the email
                        
        let promise: Promise<String> = req.eventLoop.newPromise()
                    DispatchQueue.global().async {
                       bookingSearch.networkRequest.execute(using: bookingSearch.networkRequest.request()) { data, response, error in
                            if error != nil {
                                promise.succeed(result: "error")
                            }
                            else {
                                
                                //let apiResponse = String(data: data!, encoding: .utf8)
                                let apiResponse = bookingSearch.decode(jsonData: data!)
                                var responseString = ""
                                for date in apiResponse {
                                    responseString.append("\(date.key): \(date.value) \r")
                                }
                                
                                promise.succeed(result: responseString)
                            }
                        }
                    }
        
        
        
                    
        return promise.futureResult // the result will be the respose from the API
                
    }
    
    
}
