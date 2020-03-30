
import Foundation


func getCalArray (jsonData: Data) -> [Int: Int] {
    
    let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
    let json2 = json?["item"] as! [String: Any]
    let cal = json2["cal"] as! [String: Any]
    var calArray: [Int: Int] = [0:0]

    for line in cal {
        if let key = Int(line.key) {
            calArray[key] = line.value as? Int
        }

    }
    return calArray
}



func getCalRequest () -> URLRequest{

    var request = URLRequest(url: URL(string: "http://buddhavipassana.checkfront.com/api/3.0/item/37/cal?start_date=20200401&end_date=20200630")!,timeoutInterval: Double.infinity)
    request.addValue("buddhavipassana.checkfront.com", forHTTPHeaderField: "Host")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("1", forHTTPHeaderField: "X-On-Behalf")
    request.addValue("Basic ZTZlOGQ5YzE3OTBkNTNiNDFhMWZkODFiYmQ0NmJhMTFmMjdlODRiNzo1NmFlM2VjOGNiNTBlODA1OWY3NTE4MDA4NWY2YWRhMjZhYTNlZjcxZTIxN2Y3MjQxNGE2ZmViZjkyZDEyMmI3", forHTTPHeaderField: "Authorization")

    request.httpMethod = "GET"
    return request
   
}

func test() {

    let semaphore = DispatchSemaphore (value: 0)
    var calArray :  [Int : Int] = [0:0]

    let task = URLSession.shared.dataTask(with: getCalRequest()) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      
     calArray = getCalArray(jsonData: data)
     semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    print (calArray)

}

test()
