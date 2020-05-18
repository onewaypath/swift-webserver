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

        let id = activeCampaign.createMessage(using: activeCampaign.messageHTML())
        activeCampaign.createCampaign(messageID: id)

        
        
    }
    /*
    static let allTests = [
        ("testStub", testStub),
    ]*/
}
