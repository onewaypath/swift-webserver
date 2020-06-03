//
//  BookingSearch2.swift
//  App
//
//  Created by Alex Young on 5/30/20.
//

import Foundation

struct Checkfront {
    




struct BookingSearch {

        var startDate : Date // first permissible day for booking
        var endDate : Date // last permissible day for booking
        var range = DateComponents() // the range to search in days
        let startDay = 1 // set required retreat start day to Friday (Sunday = 1)
        var availability : [Date : Int ] // a dictionary with a list of dates and the number of bookings available for each day

        var networkRequest: NetworkRequest
    
        init () {
            
            self.range.month = 3
            self.range.day = 1
            self.startDate = Date()
            self.endDate = Calendar.current.date(byAdding: self.range, to: self.startDate)!
            self.availability = [:]
            
           
            // format date for HTML request
            
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMdd")
            let startDate = dateFormatter.string(from: self.startDate)
            let endDate = dateFormatter.string(from: self.endDate)
            
            // generate HTML request
            
            let url = "http://buddhavipassana.checkfront.com/api/3.0/item/37/cal?start_date=\(startDate)&end_date=\(endDate)"
            
            let parameters = [
                "start_date" : startDate,
                "end_date" : endDate
            ]
            
            let headers = [
                "Host": "buddhavipassana.checkfront.com",
                "Accept": "application/json",
                "X-On-Behalf": "1",
                "Authorization": "Basic ZTZlOGQ5YzE3OTBkNTNiNDFhMWZkODFiYmQ0NmJhMTFmMjdlODRiNzo1NmFlM2VjOGNiNTBlODA1OWY3NTE4MDA4NWY2YWRhMjZhYTNlZjcxZTIxN2Y3MjQxNGE2ZmViZjkyZDEyMmI3"
            ]
            
            self.networkRequest = NetworkRequest(url: url, parameters: parameters, headers: headers)
            //let apiRequest = endpoint.request()
            //let apiResponse = endpoint.responseString(using: apiRequest)
            //print(apiResponse)
            
            //return apiResponse
        }
    
        func decode (jsonData: Data) -> [Date:Int] {
            
            // decode the json from a booking availability request and return the result to an dictionary of type [Data: Int]
            
            var calArray: [Int: Int] = [:]
            var calDateArray: [Date: Int] = [:]
            
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            let json2 = json!!["item"] as! [String: Any]
            let cal = json2["cal"] as! [String: Any]
           

            for line in cal {
               if let key = Int(line.key) {
                   calArray[key] = line.value as? Int
               }

            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyyMMdd"
            let myCalendar = Calendar(identifier: .gregorian)
            for date in calArray { // add result to availability array
                      let dateType = dateFormatter.date(from: String(date.key)) ?? Date() // convert to NSDate type
                      let weekDay = myCalendar.component(.weekday, from: dateType)
                if weekDay == self.startDay { // make sure start date matches the default
                          calDateArray[dateType] = date.value
                      }
            }
            return calDateArray
        }
}
}
