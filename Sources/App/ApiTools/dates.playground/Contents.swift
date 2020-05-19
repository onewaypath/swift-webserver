import UIKit

var str = "Hello, playground"


// Format the send date
var range = DateComponents()
range.day =  1
var date = Calendar.current.date(byAdding: range, to: Date())!
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
let sendDate = dateFormatter.string(from: date)
print ("\(sendDate) 00:00:00")
