//
//  ApiTools.swift
//  App
//
//  Created by Alex Young on 5/18/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class Api {
    
    var postData: [String: String]
    var url: String
    var parameters: [String: String]
    enum HTTPMethod {
        case GET, POST
    }
    var httpMethod : HTTPMethod
    
    init (url: String, parameters: [String: String], postData: [String: String] = [:]) {
        self.postData = postData
        self.url = url
        self.parameters = parameters
        
        // if the initializer includes post data then set the httpMethod to POST otherwise the get method will be used
        
        switch postData {
        case [:] :
            self.httpMethod = .GET
        default :
            self.httpMethod = .POST
        }
        
    }
    
    func dictionaryToData(using: [String:String]) -> Data? {
        
        var postDataString = ""
        
        var index = 0

        for data in using {
            if index != 0 {
                postDataString.append("&")
            }
            postDataString.append("\(data.key)=\(data.value)")
            index += 1
        }
        
        let data = postDataString.data(using: String.Encoding.utf8);
        return data
    }
    
    func dictionaryToUrlCode(using: [String:String]) -> String {
        
        var dataString = ""
        
        var index = 0

        for data in using {
            if index != 0 {
                dataString.append("&")
            }
            dataString.append("\(data.key)=\(data.value)")
            index += 1
        }
        
        return dataString
    }

    func responseString(using: URLRequest) -> String {
    
    var apiResponse: String = ""
    let semaphore = DispatchSemaphore (value: 0)
    let task = URLSession.shared.dataTask(with: using) { data, response, error in
         guard let data = data else {
             print(String(describing: error))
             return
         }
          
         apiResponse = String(data: data, encoding: .utf8)!
         semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    return apiResponse
}

    func request() -> URLRequest {
        
        let urlCode = self.dictionaryToUrlCode(using: self.parameters)
        let url = self.url + "?" + urlCode
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        
        switch self.httpMethod {
        case .POST:
            request.httpBody = dictionaryToData(using: self.postData)
            request.httpMethod = "POST"
        default:
            request.httpMethod = "GET"
        }
        
        return request
        
    }
    
    func asyncResponseString(using: URLRequest,  completion: @escaping (String) -> Void ) {
        
        var apiResponse: String = ""
        let semaphore = DispatchSemaphore (value: 0)
        let task = URLSession.shared.dataTask(with: using) { data, response, error in
             guard let data = data else {
                 print(String(describing: error))
                 return
             }
              
            apiResponse = String(data: data, encoding: .utf8)!
            completion(apiResponse)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
    }
    
}
