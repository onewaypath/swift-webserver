import XCTest
@testable import activeCampaignApi

class AppTests: XCTestCase {
    func testStub() throws {
        XCTAssert(true)
        
        print("Testing activeCampaignApi...")
    
        /*
        var tester = activeCampaignApi()
        tester.test()
        tester.addContact(firstName: "Alex", lastName: "Young", emailAddress: "rahyoung@gmail.com") { code, ID in
            tester.apiResponse = true
            tester.resultCode = code!
            tester.subscriberID = ID!
            
        }
        
        while tester.apiResponse == false {
            
        }
        
        print ("The Result Code is \(tester.resultCode) and the subscriberID is \(tester.subscriberID)") */
        
        let file = "file.txt" //this is the file. we will write to and read from it
        
        let text = "some text" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print (text2)
                print (fileURL)
            }
            catch {/* error handling here */}
        }
        
    }
 
   
    
    static let allTests = [
        ("testStub", testStub),
    ]
}
