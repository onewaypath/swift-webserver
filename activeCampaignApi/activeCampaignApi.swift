import Foundation
import Vapor

public struct activeCampaignApi {

    public init() {}
    
    public var apiResponse = false
    public var resultCode = 0
    public var subscriberID = 0
    
    public func test() {
        print("Testing activeCampaignAPi Struct...")
    }
    
    
    
    public func addContact(firstName: String, lastName: String, emailAddress: String, completionHandler: @escaping (_ code: Int?, _ ID: Int?) -> Void) {
        
        print ("adding headers...")
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "PostmanRuntime/7.15.0",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "4ccff03b-69f5-4c28-b433-9d9c6fa6df69,df131bac-7589-4375-8d81-45cf43b63302",
            "Host": "onewaypath52346.api-us1.com",
            "cookie": "__cfduid=d58ccae4405c6780544e44bb5c586a68c1561030989; PHPSESSID=l2kr72l3m3n7aakfhbev96vlb1; em_acp_globalauth_cookie=805bdaa9-c4ef-41f5-9b19-e3f226d499a8",
            "accept-encoding": "gzip, deflate",
            "content-length": "69",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        print ("headers added sucessfully")
        print ("compiling post data..")
        let postData = NSMutableData(data: "email=\(emailAddress)".data(using: String.Encoding.utf8)!)
        postData.append("&first_name=\(firstName)".data(using: String.Encoding.utf8)!)
        postData.append("&last_name=\(lastName)".data(using: String.Encoding.utf8)!)
        postData.append("&p[1]=1".data(using: String.Encoding.utf8)!)
        print ("post data successfulling compiled")
        print ("forming request...")
        let request = NSMutableURLRequest(url: NSURL(string: "https://onewaypath52346.api-us1.com/admin/api.php?api_action=contact_add&api_key=7cc162a7ee0dde7912a1ecbbb97e3e60ed4bb243e43b8683edad81826f0e7d2189dfcad2&api_output=json")! as URL,
                                          cachePolicy: .reloadIgnoringLocalCacheData,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        print ("request formed")
        print ("forming URL session...")
        let session = URLSession.shared
        print ("URL session formed")
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print ("starting datatask...")
            if (error != nil) {
                print("the http host responded with the following error:")
                print(error!)
                if (data != nil) { print("data: \(data!)") }
                if (response != nil) { print("response: \(response!)") }
            }
            else
            {
                print ("parsing data...")
                //let responseData = String(data: data!, encoding: String.Encoding.utf8)
                let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                if receivedData !=  nil
                {
                print("JSON sucessfully parsed")
                    if let resultCodeInt = receivedData!!["result_code"] as? Int, let subscriberIDInt = receivedData!!["subscriber_id"] as? Int {
                            completionHandler(resultCodeInt, subscriberIDInt)
                            print(receivedData!!.description)
                        }
                        else {
                            print ("No subscriber ID was returned. The contact is probably already in the system")
                            completionHandler(0,0)
                        }
                }
                
            }
            
            
            
            
            
            
                /*{
                if let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
    
                    print(receivedData!.description)
                    completionHandler(receivedData!.description)
                }
                else {
                    print ("error")
                }
            }*/
        })
        
        print ("resuming data task")
        dataTask.resume()
        
    }
    
    
    
    
    }
