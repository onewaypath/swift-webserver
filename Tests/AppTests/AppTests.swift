import XCTest
@testable import App

class AppTests: XCTestCase {
    func testStub() throws {
       // XCTAssert(true)
     
        /*
        let  bookingSearch = BookingSearch()
        print (bookingSearch.test())
        */
        
        let activeCampaign = ActiveCampaign()
        print (activeCampaign.reviewLists())
        /*
        let data = Data(activeCampaign.reviewLists().utf8)
        
        let json = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
        
        let sortedKeys = Array(json.keys).sorted(by: <)
        
        for key in sortedKeys {
            print (key)
            print (json[key] as Any)
        } */
       // let id = activeCampaign.createMessage(using: activeCampaign.messageHTML())
        //activeCampaign.createCampaign(messageID: id)

        
        
    }
    /*
    static let allTests = [
        ("testStub", testStub),
    ]*/
}
