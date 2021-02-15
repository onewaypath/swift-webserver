import UIKit

var str = "Hello, playground"
print (str)

func stringFromWebsite() -> String {
    if let url = URL(string: "https://raw.githubusercontent.com/onewaypath/css/master/sample/style.css") {
        do {
            let contents = try String(contentsOf: url)
            //print(contents)
            return contents
        } catch {
            return "no-css"
        }
    } else {
        return "no-css"
    }
}

let css = stringFromWebsite()
print(css)
