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

extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
}

extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.characters.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
}

struct Api {
    
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

    func responseString(using: URLRequest) -> String {
    
    //print ("starting data task")
    var apiResponse: String = ""
    let semaphore = DispatchSemaphore (value: 0)
    let task = URLSession.shared.dataTask(with: using) { data, response, error in
         guard let data = data else {
             apiResponse = (String(describing: error))
             return
         }
          
         apiResponse = String(data: data, encoding: .utf8)!
         print (apiResponse)//apiResponse = String(decoding: data, as: UTF8.self)
         //let string = (String(describing: response))
         //print(string)
         //print(apiResponse)
         semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    
    return apiResponse
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
    
    func responseStringAsync(using: URLRequest,  completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void ) {
        
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
