//
//  Covid-19.swift
//  App
//
//  Created by Alex Young on 4/13/20.
//

//import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}


final class Jurisdiction  {

    //***CONSTANTS***
    
    let rows: [Int]
    let label: String
    let colour: String
    let csvData: [[String]]
    let dataSource: String
    
 
    
    init(rows: [Int], label: String, colour: String, csvData: [[String]], dataSource: String = "global") {
        self.rows = rows
        self.label = label
        self.colour = colour
        self.csvData = csvData
        self.dataSource = dataSource
    }

    // ***SUBCLASSES***
    
    class Dates {
        
        var reportedDates: [String] = []
        
        func decode(master:Jurisdiction) {
            //decode the reported dates array
            var index = 0
            for column in master.csvData[0] {
                if (master.dataSource == "global" && index > 4) || (master.dataSource == "US" && index > 13) {
                    reportedDates.append(column)
               }
                index+=1
            }
        //print("reported dates")
        }
    }
    
    // Datafield variables are variables are raw data variables
    class Datafields {
       
        var dailyTotals: [Int] = []
        var dailyChanges: [Int] = []
        var movingAverages: [Double] = []
        
        func decode(master:Jurisdiction) {

            // decode the subject field and add a daily changes field
            
            var deathsThisDay = 0
            var deathsLastDay = 0
            var i = 0
            var columnID: Int
            
            for row in master.rows {
                
                
                i = 0
                columnID = 0
                
                for column in master.csvData[row-1] {
                    if (master.dataSource == "global" && column.isInt) || (columnID > 13) {
                        
                        deathsThisDay = Int(column) ?? 0
                        if !master.datafields.dailyTotals.indices.contains(i)   {
                            master.datafields.dailyTotals.append(deathsThisDay)
                            master.datafields.dailyChanges.append(deathsThisDay - deathsLastDay)
                        }
                        else {
                            master.datafields.dailyTotals[i] += deathsThisDay
                            //rint(master.datafields.dailyTotals[i])
                            master.datafields.dailyChanges[i] += (deathsThisDay - deathsLastDay)
                        }
                        i += 1
                        deathsLastDay = deathsThisDay
                    }
                    columnID += 1
                }
                //print("datafields")
            }
            
            // create an array for 7-day moving average

            var index = 0
            var sum = 0
            var avg: Double = 0
            for _ in master.datafields.dailyChanges {
                if index > 6 {
                    for i in (index-6)...index {
                        sum += master.datafields.dailyChanges[i]
                    }
                    avg = Double(sum) / 7
                    master.datafields.movingAverages.append(avg)
                    sum = 0
                }
                else {
                    master.datafields.movingAverages.append(0)
                }
                index+=1
            }
            //print("movingAverages")
        } // end of decode funtion
        
    }
    
    
    // Production variables are variables that will be included in final output
    class Production {
        var dates: [String] = []
        var avgChanges: [Double] = []
        var days: [Int] = []
        var firstAvgChange : Int = 0
        
        
        func decode(master:Jurisdiction) {
            
            // determine date when avg new deaths is greater than or equal to 3
            var index = 0
            for avgNewDeath in master.datafields.movingAverages {
                
                if avgNewDeath >= 3 {
                    firstAvgChange = index
                    break
                }
                index+=1
            }
            
            
            var i = 0
                for index in firstAvgChange...master.dates.reportedDates.count-1 {

                dates.append(master.dates.reportedDates[index])
                days.append(i)
                avgChanges.append(master.datafields.movingAverages[index])
                
                i+=1
            }
            //print("production")
            
        }
        
    }
    
    // *** VARIABLES ***
    
    var dates = Dates()
    var datafields = Datafields()
    var production = Production()

    // *** CLASS METHODS ***
    
    func outputHTML() -> String {

        dates.decode(master:self)
        datafields.decode(master: self)
        production.decode(master: self)
        
        //print("debug")
        let data: String = "{label: \'\(self.label)\', borderColor: \'\(self.colour)\', fill: false, data: \(production.avgChanges)}"
        return data
    }
}

