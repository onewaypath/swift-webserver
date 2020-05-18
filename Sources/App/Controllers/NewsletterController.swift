//
//  NewsletterController.swift
//  App
//
//  Created by Alex Young on 5/17/20.
//

import Foundation
import Vapor
import unixTools

final class NewsletterController {
    
    func test(_ req: Request) throws -> Future<View> {
        
        // let content = "This is the email"
        let author = "Alex Young"
        
        let testFile = "Public/getOutput.html"
        let htmlFile = "emailTest.html"
        let htmlFilePath = "Public/\(htmlFile)"
        let htmlTemplate = unixTools().runUnix("cat", arguments: [htmlFilePath])
        
        let html = htmlTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
        
        
        
        
        _ = unixTools().runUnix("rm", arguments:["-rf", testFile])
        _ = unixTools().runUnix("touch", commandPath: "/usr/bin/", arguments: [testFile])
        unixTools().runUnixToFile("echo", arguments: [html], filePath: testFile)
        return try req.view().render("main-template", ["html": html])
    }
    
    
    
    
    func post(_ req: Request) throws -> Future<HTTPStatus> {
    
         struct MessageRequest: Content {
             var content: String
             var author: String
            var subject: String
         }
         
         return try req.content.decode(MessageRequest.self).map(to: HTTPStatus.self) { messageRequest in
             print("author: \(messageRequest.author)")
             print("content: \(messageRequest.content)")
            print ("subject: \(messageRequest.subject)")
            
            /*
             let content = """
                <p>As we progress in life, success will inevitably lead to greater rewards but also greater responsibility. Stress resulting from having too many things to do is a sign of progress rather than a cause for concern. However, new challenges require us to also acquire new skills to deal with our additional workload. When we are overwhelmed with work, the only way to solve the problem is to establish clear priorities.</p> <p>Ironically, our first priority needs to be the process of setting priorities itself. Perhaps that feels like a waste of time but nothing could be further from the truth. The simple reality is that the benefit we gain from efficient activity is exponentially greater than the benefit we gain from other less productive uses of our time. The most effective way to accomplish priority setting is through spiritual practice. This is so because when we engage in introspection, we are essentially determining what outcomes are most important to us in life. There is no better use of our time because, by reflecting on our priorities, we can eliminate most of the wasteful busy work and focus on those actions that actually result in satisfaction.</p> <p>The process of introspection that the Buddha laid down for us is surprisingly simple. In order to understand what we should do next, we need to bring the mind to what we are doing now. This process is called mindfulness because we fill the mind with the present moment. Another way to describe mindfulness is to call it insight meditation because by bringing the mind into the present moment, we gain insight into the true nature of reality as we experience it from moment to moment. This in turn results in enhanced clarity about how we can become satisfied.</p> <p>In summary then, we should not become discouraged when we feel overwhelmed. We should instead use this feeling to guide us towards an even greater destination. That destination which we are all capable of reaching is one where our minds are no longer trapped in worries about the future or lamenting the past but rather firmly established and rejoicing in the present moment.</p>
"""
            let author = "Alex Young" */
            let content = messageRequest.content
            let author = messageRequest.author
            let subject = messageRequest.subject
            
            let testFile = "Public/postOutput.html"
            let htmlFile = "emailTest.html"
            let htmlFilePath = "Public/\(htmlFile)"
            let htmlTemplate = unixTools().runUnix("cat", arguments: [htmlFilePath])
            
            let html1 = htmlTemplate.replacingOccurrences(of: "[NAME OF AUTHOR]", with: author)
            let html = html1.replacingOccurrences(of: "[CONTENT GOES HERE]", with: content)
            
            // Format the send date
            var range = DateComponents()
            range.day =  1
            let date = Calendar.current.date(byAdding: range, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sendDate = dateFormatter.string(from: date)
            print ("\(sendDate) 00:00:00")

            // Post the message to ActiveCampaign
            
            let activeCampaign = ActiveCampaign()
            let id = activeCampaign.createMessage(using: html)
            activeCampaign.createCampaign(messageID: id, messageName: subject, sdate: sendDate)
            
            // Save the output to a local test file for debugging
            
            _ = unixTools().runUnix("rm", arguments:["-rf", testFile])
            _ = unixTools().runUnix("touch", commandPath: "/usr/bin/", arguments: [testFile])
            unixTools().runUnixToFile("echo", arguments: [html], filePath: testFile)
            //return try req.view().render("main-template", ["html": html])
            
             return .ok
         }
     }
    
}
