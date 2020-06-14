import UIKit

var str = "Hello, playground"



    
    func indexInString(of: Character, within: String, startingFrom: Int) -> String.Index {
        
        let startingFromIndex = within.index(within.startIndex, offsetBy: startingFrom)
        
        let searchString = String(within[startingFromIndex..<within.endIndex])
        
        var targetIndexInt = 0
        var x: Int = 0
        
        for c in searchString {
            if c == of {
                targetIndexInt = x
                break
            }
        x = x + 1
        }
        return within.index(within.startIndex, offsetBy: targetIndexInt + startingFrom)
    }
    
let index = indexInString(of: "l", within: str, startingFrom: 3 )
let newString = String(str[index..<str.endIndex])
print (newString)
