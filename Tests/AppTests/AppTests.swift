import XCTest
@testable import App

class AppTests: XCTestCase {
    func testStub() throws {
       // XCTAssert(true)
     
        /*
        let  bookingSearch = BookingSearch()
        print (bookingSearch.test())
        */
        
        
        let covid19ChartsController = Covid19ChartsController()
        print(covid19ChartsController.outputHTML(field: "deaths"))
        
    }
    /*
    static let allTests = [
        ("testStub", testStub),
    ]*/
}
