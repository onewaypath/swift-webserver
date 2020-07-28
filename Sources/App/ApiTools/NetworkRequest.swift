//
//  NetworkRequest.swift
//  App
//
//  Created by Alex Young on 5/30/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct NetworkRequest {
    
    var postData: [String: String]
    var url: String
    var parameters: [String: String]
    var headers: [String: String]
    var jsonBody: Data?
    
    enum HTTPMethod {
        case GET, POST
    }
    var httpMethod : HTTPMethod
    
    init (url: String, parameters: [String: String], headers: [String:String] = [:], postData: [String: String] = [:], jsonBody: Data? = nil) {
        self.postData = postData
        self.url = url
        self.parameters = parameters
        self.headers = headers
        self.jsonBody = jsonBody
        
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


    func request() -> URLRequest {
        
        let urlCode : String? = self.dictionaryToUrlCode(using: self.parameters)
        let url = self.url + "?" + (urlCode ?? "")
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        
        // add headers if any
        for header in self.headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        switch self.httpMethod {
        case .POST:
            if self.postData["json"]?.data(using: String.Encoding.utf8)  != nil {
                request.httpBody = self.jsonBody
                //let jsonString = String(data: self.jsonBody!, encoding: .utf8)!
                //print (jsonString)
            }
            else {
                request.httpBody = dictionaryToData(using: self.postData)
            }
            request.httpMethod = "POST"
        default:
            request.httpMethod = "GET"
        }
        
        return request
        
    }
    
    func execute(using: URLRequest,  completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void ) {
        
        //var apiResponse: String = ""
        
        let task = URLSession.shared.dataTask(with: using) { data, response, error in
             guard let data = data else {
                 completion(nil, nil, error)
                 //print(String(describing: error))
                 return
             }
              
            completion(data, response, nil)
            
        }

        task.resume()
        
    }
    
}
