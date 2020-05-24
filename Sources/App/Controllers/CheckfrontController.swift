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

    func availability (_ req: Request) throws -> Future<View> {
        let bookingSearch = BookingSearch()
        
        
        var output = ""
         
         // create and make the URL request; store the response as an array in CalArray
        let semaphore = DispatchSemaphore (value: 0)
        let task = URLSession.shared.dataTask(with: bookingSearch.request()) { data, response, error in
             guard let data = data else {
                 output = (String(describing: error))
                 return
             }
              
             bookingSearch.availability = bookingSearch.decode(jsonData: data)
             output = bookingSearch.test(arrayData: bookingSearch.availability)
             semaphore.signal()
        }

        task.resume()
        semaphore.wait()


        return try req.view().render("main-template", ["html": output])
        
    }

    
  
    
    func networkRequest (completion: @escaping (String) -> Void) {
        let bookingSearch = BookingSearch()
        
        
    
         
         // create and make the URL request; store the response as an array in CalArray
        //let semaphore = DispatchSemaphore (value: 0)
        let task = URLSession.shared.dataTask(with: bookingSearch.request()) { data, response, error in
             guard let data = data else {
                 //output = (String(describing: error))
                 return
             }
              
             bookingSearch.availability = bookingSearch.decode(jsonData: data)
             let output = bookingSearch.test(arrayData: bookingSearch.availability)
             completion(output)
            //semaphore.signal()
        }

        task.resume()
        //semaphore.wait()



        
    }
    
    func availabilityAsync (_ req: Request) throws -> Future<String> {
        
        let promise: Promise<String> = req.eventLoop.newPromise()

        DispatchQueue.global().async {
            self.networkRequest() {response in
            promise.succeed(result: response)
            }
            
        }

        return promise.futureResult
        
    
    }
    
}
