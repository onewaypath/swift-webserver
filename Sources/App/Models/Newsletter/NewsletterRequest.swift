//
//  NewsletterRequest.swift
//  App
//
//  Created by Alex Young on 6/1/20.
//

import Foundation
import Vapor
import unixTools

struct NewsletterRequest: Content {
    
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
        
        let defaultTemplate = "emailTemplate.html"
        let defaultAuthor = "Alex Young"
        let defaultContent = unixTools().runUnix("cat", arguments: ["Public/emailContent.html"])
       
        self.author = postRequest.author
        self.subject = postRequest.subject ?? "Test: What To Do When We're Overwhelmed"
        self.template = postRequest.template
        self.distributionList = postRequest.distributionList
        self.email = postRequest.email
        self.content = postRequest.content
        
        
        // prepare the HTML content
        
        let template = unixTools().runUnix("cat", arguments: ["Public/\(self.template ?? defaultTemplate)"])
        var html = template.replacingOccurrences(of: "[NAME OF AUTHOR]", with: self.author ?? defaultAuthor)
        let content = html.slice(from: "<section>", to: "</section>")
        html = html.replacingOccurrences(of: content!, with: self.content ?? defaultContent)
        self.content = html
        
        // prepare the send date
        var range = DateComponents()
        range.day =  1
        let date = Calendar.current.date(byAdding: range, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sendDate = dateFormatter.string(from: date)
        print ("\(sendDate) 00:00:00")
        self.sdate = sendDate
        
    }

}


