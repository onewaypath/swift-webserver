//
//  BookingSearchModel.swift
//  App
//
//  Created by Alex Young on 3/28/20.
//



import Foundation

final class BookingSearch {
    
    var startDate : Date // first permissible day for booking
    var endDate : Date // last permissible day for booking
    var range = DateComponents() // the range to search in days
    let startDay = 1 // set required retreat start day to Friday (Sunday = 1)
    var availability : [Date : Int ] // a dictionary with a list of dates and the number of bookings available for each day
    
    init () {
        
        self.range.month = 3
        self.range.day = 1
        self.startDate = Date()
        self.endDate = Calendar.current.date(byAdding: self.range, to: self.startDate)!
        self.availability = [:]
        
        
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

    func request () -> URLRequest{

        
        // format date for HTML request
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMdd")
        let startDate = dateFormatter.string(from: self.startDate)
        let endDate = dateFormatter.string(from: self.endDate)
        
        // generate HTML request
        
        var request = URLRequest(url: URL(string: "http://buddhavipassana.checkfront.com/api/3.0/item/37/cal?start_date=\(startDate)&end_date=\(endDate)")!,timeoutInterval: Double.infinity)
        request.addValue("buddhavipassana.checkfront.com", forHTTPHeaderField: "Host")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("1", forHTTPHeaderField: "X-On-Behalf")
        request.addValue("Basic ZTZlOGQ5YzE3OTBkNTNiNDFhMWZkODFiYmQ0NmJhMTFmMjdlODRiNzo1NmFlM2VjOGNiNTBlODA1OWY3NTE4MDA4NWY2YWRhMjZhYTNlZjcxZTIxN2Y3MjQxNGE2ZmViZjkyZDEyMmI3", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        return request
       
    }
    
    func test(arrayData: [Date: Int]) -> String {

        // generate a string containing all the entries in the availability array so that the contents of that, for debugging purposes, the contents of that array can be checked
        
        let dateFormatter = DateFormatter()
        var output = ""
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, YYYY") // set template after setting locale
        let keys = Array(arrayData.keys)
        for date in keys.sorted(by: <) {
          let formattedDate = dateFormatter.string(from: date)
          //print( "\(formattedDate) -> \(self.availability[date])" )
          output.append("\(formattedDate) -> \(arrayData[date] ?? 0) <br>")
        }
        
        return output
    }

    
    
}

