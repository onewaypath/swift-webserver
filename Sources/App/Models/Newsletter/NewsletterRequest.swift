//
//  NewsletterRequest.swift
//  App
//
//  Created by Alex Young on 6/1/20.
//

import Foundation
import Vapor
import unixTools

/*
extension String {
    func index(of string: String, from startPos: Index? = nil, options: CompareOptions = .literal) -> Index? {
        if let startPos = startPos {
            return range(of: string, options: options, range: startPos ..< endIndex)?.lowerBound
        } else {
            return range(of: string, options: options)?.lowerBound
        }
    }
}*/


struct NewsletterRequest: Content {
    
    //var htmlContent: String?
    //var textContent: String?
    var content: String?
    var author: String?
    var subject: String?
    var template: String?
    var distributionList: String?
    var email: Bool?
    var html: String?
    var sdate: String?

    //init(content: String? = nil, author: String? = "Alex Young", subject: String? = "Test Subject", template: String? = "emailTemplate.html", distributionList: String? = nil, testEmailAddress: String? = nil) {
    init(postRequest: NewsletterRequest) {
        
        let defaultTemplate = "Public/emailTemplates/emailTemplate.html"
        let defaultAuthor = "Miriam Young"
        let defaultContent = unixTools().runUnix("cat", arguments: ["Public/emailTemplates/emailContent.html"])
       
        self.author = postRequest.author ?? defaultAuthor
        self.subject = postRequest.subject ?? "Test: What To Do When We're Overwhelmed"
        self.template = postRequest.template ?? defaultTemplate
        self.distributionList = postRequest.distributionList
        self.email = postRequest.email
        self.content = postRequest.content ?? defaultContent
        //self.htmlContent = postRequest.htmlContent
        
        
        // prepare the HTML content
        
        
        //var html = template.replacingOccurrences(of: "[NAME OF AUTHOR]", with: self.author ?? defaultAuthor)
        //let content = html.slice(from: "<section>", to: "</section>")
        //html = html.replacingOccurrences(of: content!, with: self.content ?? defaultContent)
        //self.htmlContent = template
        
        // prepare the text content
        //self.textContent = "Test Text"
        
        // prepare the send date
        var range = DateComponents()
        range.day =  1
        let date = Calendar.current.date(byAdding: range, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sendDate = dateFormatter.string(from: date)
        //print ("\(sendDate) 00:00:00")
        self.sdate = sendDate
        
    }
    
    func indexInString(of: Character, within: String, startingFrom: Int) -> String.Index {
        
        // This function returns the position of a given character within a String starting at a given position.
        
        let startingFromIndex = within.index(within.startIndex, offsetBy: startingFrom)
        
        let searchString = String(within[startingFromIndex..<within.endIndex])
        //print(searchString)
        var targetIndexInt = 0
        var x: Int = 0
        
        for c in searchString {
            if c == of {
                targetIndexInt = x
                break
            }
        x = x + 1
        }
        //print(targetIndexInt)
        return within.index(within.startIndex, offsetBy: targetIndexInt + startingFrom + 1)
    }
    
    
    func sliceHtmlTag(template: String, tag: String, tagNumber: Int, replaceWith: String? = nil) -> String {
        
        // This function takes a String (template), an HTML tag name (tag) and the order of the tag in the file (e.g., if you are targetting the first tag, pass "1" through the tagNumber parameter array.
        
        // The function will return an array with the text inside the tags replacing any instances of <br> with a new line. If <p> </p> pairs are encountered, the function inserts two new lines to create a paragraph.
        
        //If you pass a replaceWith array, the function will return one item in the array which will be your original string with the text in the tags replaced with your replacement text.
        
        var str = template
        let openTag = "<\(tag)"
        let closeTag = "</\(tag)>"
        let openStartIndices = str.indices(of: openTag)
        var x = 0
        var closeStartIndices = [0]
        var targetIndex: String.Index
        //var startPosIndex: String.Index
        var newElement = 0
        //print(openStartIndices)
        //print("debug")
        for startPos in openStartIndices {
            //print(startPos)
            //startPosIndex = str.index(str.startIndex, offsetBy: startPos)
            //targetIndex = str.index(of: ">", from: startPosIndex)!
            targetIndex = indexInString(of: ">", within: str, startingFrom: startPos)
            newElement = str.distance(from: str.startIndex, to: targetIndex)
            if closeStartIndices[0] == 0 {
                closeStartIndices[0] = newElement
            }
            else {
                 closeStartIndices.append(newElement)
            }
            x = x + 1

        }
        //print("debug2")
        //print(closeStartIndices)
        //var cPosIndex: String.Index
        /*
        for cPos in closeStartIndices {
            var cPosIndex = str.index(str.startIndex, offsetBy: cPos)
            //print(String(str[cPosIndex]))
            //print(" ")
        }*/
        //print("debug3")
        
        let closeIndices = str.indices(of: closeTag)
        //print(closeIndices)
        //let closeStartIndex = str.index(str.startIndex, offsetBy: closeStartIndices[tagNumber-1])
        let index1 = str.index(str.startIndex, offsetBy: closeStartIndices[tagNumber-1])
        let index2 = str.index(str.startIndex, offsetBy: closeIndices[tagNumber-1])
        let range: Range<String.Index> = index1..<index2
            if replaceWith != nil {
                str.replaceSubrange(range, with: replaceWith!)
            }
            else {
                var returnString = String(str[range])
                returnString = returnString.replacingOccurrences(of: "<p>", with: "\n")
                returnString = returnString.replacingOccurrences(of: "</p>", with: "\n")
                returnString = returnString.replacingOccurrences(of: "<br>", with: "\n")
                
                return returnString //if replaceWith is not provided then just return the substring inside the tag
            }
           return str
       }
    
    func htmlContent() -> String {
    
        let template = unixTools().runUnix("cat", arguments: ["Public/\(self.template!)"])
        
        // replace the title in the template
         var returnString = sliceHtmlTag(template: template, tag: "title", tagNumber: 1, replaceWith: self.subject!)
        
        // replace the content in the template
        returnString = sliceHtmlTag(template: returnString, tag: "section", tagNumber: 3, replaceWith: self.content!)
        
        returnString = returnString.replacingOccurrences(of: "[NAME OF AUTHOR]", with: self.author!)
        
        return returnString
    }
               
    func textContent() -> String {
        
       // prepare the text content of the email message
        //let sourceTemplate = unixTools().runUnix("cat", arguments: ["Public/emailTemplate4.html"])
        //let mainTextContent = sliceHtmlTag (template: sourceTemplate, tag: "section", tagNumber: 3)
        let mainTextContent = self.content ?? unixTools().runUnix("cat", arguments: ["Public/emailContent.txt"])
        
        
        let targetTemplate = unixTools().runUnix("cat", arguments: ["Public/emailTemplates/emailTemplatePlain.txt"])
        
        
        let replacementDictionary = [
            "[MESSAGE CONTENT]" : mainTextContent,
            "[MESSAGE SUBJECT]" : self.subject!.uppercased(),
            "[NAME OF AUTHOR]" : self.author!,
            "<p>" : "\n",
            "</p>" : "\n",
            "<br> " : "\n"
        ]
            
        var returnString = targetTemplate
        
        for content in replacementDictionary {
           
            returnString = returnString.replacingOccurrences(of: content.key, with: content.value)
            
        }
        
        return returnString
    }

}


