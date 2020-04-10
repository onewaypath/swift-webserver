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
    var range = DateComponents() // the range to searhc in days
    let startDay = "Friday" // required retreat start day
    var availability : [Date : Int ] // a dictionary with a list of dates and the number of bookings available for each day
    
    init () {
        
        self.range.month = 3
        self.range.day = 1
        self.startDate = Date()
        self.endDate = Calendar.current.date(byAdding: self.range, to: self.startDate)!
        self.availability = [:]
        
        
    }
    
 /*   func listStartDates() {
        
        let myCalendar = Calendar(identifier: .gregorian)
        
        var date = self.startDate
        var interval = DateComponents()
        interval.day = 1
        
        while date < self.endDate {
             
            let weekDay = myCalendar.component(.weekday, from: date)
            if weekDay == 6 {
                self.availability[date] = 1
                //print(date)
            }
            date = Calendar.current.date(byAdding: interval, to: date)!
        }
        
        let keys = Array(self.availability.keys)
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, YYYY") // set template after setting locale
        
        for date in keys.sorted(by: <) {
            print(dateFormatter.string(from: date))
            
        }
        
        
    }*/
    

    func decodeCalArray (jsonData: Data) -> [Int: Int] {
        
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        let json2 = json!!["item"] as! [String: Any]
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
          
         calArray = self.decodeCalArray(jsonData: data)
         semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        // convert the dates from checkfront to NSDate format and add the dates that match the start day of the week (Friday) to the availability array.
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyyMMdd"
        let myCalendar = Calendar(identifier: .gregorian)
        
        for date in calArray { // add result to availability array
            let dateType = dateFormatter.date(from: String(date.key)) ?? Date() // convert to NSDate type
            let weekDay = myCalendar.component(.weekday, from: dateType)
            if weekDay == 6 { // make sure start date is Friday
                self.availability[dateType] = date.value
            }
        }
       
        // sort the availability array and print out the array values
        
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, YYYY") // set template after setting locale
        let keys = Array(self.availability.keys)
        for date in keys.sorted(by: <) {
            let formattedDate = dateFormatter.string(from: date)
            print( "\(formattedDate) -> \(self.availability[date])" )
        }
        
        //print (calArray)

    }
    
    
}

