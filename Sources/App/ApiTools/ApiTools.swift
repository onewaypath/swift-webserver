//
//  ApiTools.swift
//  App
//
//  Created by Alex Young on 5/18/20.
//

import Foundation

final class Api {
    
    var postData: [String: String]
    var url: String
    var parameters: [String: String]
    
    
    init (url: String, parameters: [String: String], postData: [String: String]) {
        self.postData = postData
        self.url = url
        self.parameters = parameters
        
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
        request.httpBody = dictionaryToData(using: self.postData)
        request.httpMethod = "POST"
        return request
        
    }
    
}
