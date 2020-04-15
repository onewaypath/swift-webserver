//
//  Covid-19DeathsController.swift
//  App
//
//  Created by Alex Young on 4/13/20.
//

import Foundation
import Vapor
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class Covid19ChartsController {
    
    func request(url: String) -> String {
        let semaphore = DispatchSemaphore (value: 0)
        var responseString : String = ""
        
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          responseString = (String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return responseString
    }
    
    func outputHTML(field: String) -> String {
    

    // Fetch the global data from the site
        
        var content: String = ""
        
        
        switch field {
        
        case "deaths" :
            content = request(url: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
            
        default :
            content = request(url: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
        }
        
    var parsedCSV: [[String]] = content.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }

    // add class instances of desired jurisdictions to an array
    var jurisdictions : [Jurisdiction] = []
    jurisdictions.append(Jurisdiction(rows: [44], label: "Ontario", colour: "red", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: [38], label: "British Columbia", colour: "blue", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: [46], label: "Quebec", colour: "yellow", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: [145], label: "South Korea", colour: "green", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: [139], label: "Italy", colour: "purple", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: [64], label: "Hubei", colour: "orange", csvData: parsedCSV ))
    //jurisdictions.append(Jurisdiction(rows: [206], label: "Sweden", colour: "black", csvData: parsedCSV ))
    jurisdictions.append(Jurisdiction(rows: Array(37...47), label: "Canada", colour: "brown", csvData: parsedCSV ))
    // create a string containing the desired datasets
    
    // add US data
        
    switch field {
        
        case "deaths" :
            content = request(url: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
            
        default :
            content = request(url: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
        }
        
    parsedCSV = content.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        
    jurisdictions.append(Jurisdiction(rows: Array(1835...1896), label: "NY State", colour: "black", csvData: parsedCSV, dataSource: "US" ))
    
    jurisdictions.append(Jurisdiction(rows: Array(2...3254), label: "USA", colour: "grey", csvData: parsedCSV, dataSource: "US" ))

        
    // prepare the datasets for html output
        
    var dataset : String = ""
    var maxDays : Int = 0
    var refDates : [Int] = []

    dataset.append("[")
        var i = 0
        for jurisdiction in jurisdictions {
            dataset.append(jurisdiction.outputHTML())
            if i != jurisdictions.count - 1 {
                dataset.append(",")
            }
            // track the size of each dataset and assign the largest dataset to refDates to be added to the label in the HMTL
            if jurisdiction.production.days.count > maxDays {
                refDates = jurisdiction.production.days
                maxDays = jurisdiction.production.days.count
            }
            
            i+=1
        }
    dataset.append("]")

        var chartTitle: String
        var xAxisTitle: String
        var yAxisTitle: String
        
        switch field {
        case "deaths" :
            chartTitle = "COVID-19 Related Deaths Per Day (7-Day Moving Average)"
            xAxisTitle = "Days Since 3 Deaths Recorded"
            yAxisTitle = "Deaths Per Day"
            
        default :
            chartTitle = "COVID-19 New Cases Per Day (7-Day Moving Average)"
            xAxisTitle = "Days Since 3 New Cases Recorded"
            yAxisTitle = "New Cases Per Day"
        }
    // *** HTML Templete

        
    let html = """
    <!doctype html>

    <canvas id="myChart3"></canvas>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>


    <html>
    <head>
    <meta charset="UTF-8">
    <title>\(chartTitle)</title>
    </head>

    <body>

    <script>
    Chart.scaleService.updateScaleDefaults('logarithmic', {
      ticks: {
        callback: function(tick, index, ticks) {
          return tick.toLocaleString()
        },
        callback: function(label, index)
          { console.log(index); return index % 5 === 0 ? label: '';}
      }
    });
    var ctx3 = document.getElementById('myChart3').getContext('2d');
    var chart3 = new Chart(ctx3, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: \(refDates),
            datasets: \(dataset)

        },

        // Configuration options go here
        options: {
            title: {
                       display: true,
                       text: '\(chartTitle)',
                       fontSize: '22'
                   },
                   
                   legend: {
                       position: 'bottom',
                           },
            scales: {
                yAxes: [{
                    id: 'first-y-axis',
                    type: 'logarithmic',
                    scaleLabel: {
                        labelString: '\(yAxisTitle)',
                        display: 'true',
                        fontSize: '16'},
                    ticks: {
                        stepSize: 100
                    }
                }],
                 xAxes: [{
                    id: 'first-x-axis',
                    
                    scaleLabel: {
                        labelString: '\(xAxisTitle)',
                        display: 'true',
                        fontSize: '16'}
                    
                }]
            }
        }
        
    });
    </script>
        
        
    </body>
    </html>
    """
    return html
    }
    
    func view(_ req: Request) throws -> Future<View> {
            
        let field = try req.parameters.next(String.self)
        let html = outputHTML(field: field)
        return try req.view().render("main-template", ["html": html])
    }
}
