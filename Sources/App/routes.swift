import Vapor
import activeCampaignApi

struct UsersFilters: Content {
    var firstName: String
    var lastName: String
    var email: String
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // "It works" page
    
    
    
    router.get("subscribe") { req -> Future<View> in
        
        let filters = try req.query.decode(UsersFilters.self)
        
        let firstName = filters.firstName
        let lastName = filters.lastName
        let email = filters.email
        
        var tester = activeCampaignApi()
        tester.test()
        tester.addContact(firstName: firstName, lastName: lastName, emailAddress: email) { code, ID in
            tester.apiResponse = true
            tester.resultCode = code!
            tester.subscriberID = ID!
            
        }
        
        while tester.apiResponse == false {
            
        }
        
        let data = ["subscriberID": tester.subscriberID]
        return try req.view().render("subscribe", data)
        //return "user id #\(tester.subscriberID), First Name #\(firstName), Last Name #\(lastName), Email #\(email)"
    }
    
   
    
    router.get { req in
        return try req.view().render("legal")
    }
    
    /*router.get ("funding", "01") { req in
        return try req.view().render("funding-01")
    }
    
    router.get ("funding", "02") { req in
        return try req.view().render("funding-02")
    }*/
    
    router.get ("legal") { req in
        return try req.view().render("legal")
    }
    
    router.get ("incorporation") { req in
        return try req.view().render("incorporation-03")
    }
    
    router.get ("pricing") { req in
        return try req.view().render("pricing")
    }
    
    /*router.get ("incorporation", "02") { req in
        return try req.view().render("incorporation-02")
    }*/
    
    /*router.get("contactAdded") { req -> Future<View> in
    
    
        var tester = activeCampaignApi()
        tester.test()
        tester.addContact(firstName: "Alex", lastName: "Young", emailAddress: "rahyoung@gmail.com") { code, ID in
            tester.apiResponse = true
            tester.resultCode = code!
            tester.subscriberID = ID!
            
        }
        
        while tester.apiResponse == false {
            
        }
        return try req.view().render("funding-01")
        
    }*/
    
    /*router.get("bonus") { req -> Future<View> in
        var o365User = O365UserStruct()
        //var availabilityResponse = "undefined"
        o365User.accessToken = "eyJ0eXAiOiJKV1QiLCJub25jZSI6IkFRQUJBQUFBQUFEQ29NcGpKWHJ4VHE5Vkc5dGUtN0ZYaU5vLXozWWpjS2w2Vm8wZzRtRDJvZ0dzVzhsbU16VE9BU1c2b1ZDYlhiWGt3RFlQNUdfX1d1d3hLRVg5cDJVOFh4S0hUYWYtQXVmVjFacVR6S1VpQVNBQSIsImFsZyI6IlJTMjU2IiwieDV0IjoiQ3RmUUM4TGUtOE5zQzdvQzJ6UWtacGNyZk9jIiwia2lkIjoiQ3RmUUM4TGUtOE5zQzdvQzJ6UWtacGNyZk9jIn0.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83Nzk2ODViNy1hYjY1LTQxMTItYWM1OC0yYzZmODRhMjIxZjQvIiwiaWF0IjoxNTYwODA2NTA5LCJuYmYiOjE1NjA4MDY1MDksImV4cCI6MTU2MDgxMDQwOSwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFTUUEyLzhMQUFBQXcwa1hLbGQrMUlEbXR6WFN2VVJoZThQeDRGQm1sdGJTYk5yYWFZRGtBSFE9IiwiYW1yIjpbInB3ZCJdLCJhcHBfZGlzcGxheW5hbWUiOiJTd2lmdCBSRVNUIENvbm5lY3QgU2FtcGxlIiwiYXBwaWQiOiJhYzhlYzBlMi05ZWNmLTQ3ZTktYjBiYy1mYmIwNzIyMjdmYzEiLCJhcHBpZGFjciI6IjEiLCJmYW1pbHlfbmFtZSI6IllvdW5nIiwiZ2l2ZW5fbmFtZSI6IkFsZXgiLCJpcGFkZHIiOiIzOC45OS4xODYuNjgiLCJuYW1lIjoiQWxleCBZb3VuZyIsIm9pZCI6ImYzM2FhZjE0LTAyZGEtNGUzNi05MDc3LTc5MGE5NmEwZWM0OCIsInBsYXRmIjoiNSIsInB1aWQiOiIxMDAzMjAwMDNFMzZDMkE3Iiwic2NwIjoiQm9va2luZ3MuTWFuYWdlLkFsbCBCb29raW5ncy5SZWFkLkFsbCBCb29raW5ncy5SZWFkV3JpdGUuQWxsIENhbGVuZGFycy5SZWFkIENhbGVuZGFycy5SZWFkLlNoYXJlZCBDYWxlbmRhcnMuUmVhZFdyaXRlIENhbGVuZGFycy5SZWFkV3JpdGUuU2hhcmVkIHByb2ZpbGUgb3BlbmlkIGVtYWlsIiwic2lnbmluX3N0YXRlIjpbImttc2kiXSwic3ViIjoiSnp3WFNtT3lvRFNXdGNmRXFZcXQtbXluc093bE5RbGRZYTJhZ1Q1VGJxOCIsInRpZCI6Ijc3OTY4NWI3LWFiNjUtNDExMi1hYzU4LTJjNmY4NGEyMjFmNCIsInVuaXF1ZV9uYW1lIjoiYXlvdW5nQG9uZXdheXBhdGguY29tIiwidXBuIjoiYXlvdW5nQG9uZXdheXBhdGguY29tIiwidXRpIjoiYzVnd2VhQWRjRXVlOVBPVE0xZ0hBQSIsInZlciI6IjEuMCIsIndpZHMiOlsiNjJlOTAzOTQtNjlmNS00MjM3LTkxOTAtMDEyMTc3MTQ1ZTEwIl0sInhtc19zdCI6eyJzdWIiOiJPTlJ3OU82cHlZTlpWU3ZtVXNfekRIMUFQVm1MY1pLaUpCZm1WSV9FMHY0In0sInhtc190Y2R0IjoxNTUxMzE2MjY0fQ.YVdH4tsguNJ_5P7PUFRm5qNGpWMkZd2cRKttdlt-UlSG4Vqy9w3EY9pdINXNY1kUuQV9rQdLWUPJt8OhIPW65IECNPma1GUvWhAMCG19U-VZuJkwzOAb4upAgBASfCQWe-ujlukzA5xj7HbUPfXK6YZIKlCWj4cB4I9LMBVGq9x0sKmtf6w5mI_vZ3VDTUIoq__Knmvybxz81_IT9mnervE4PsxVu1eE2dS6F6-lNXdO1IDjnDUf-5dz-BrARX5kLH-Ml3wRvGZkdsv6lHLUtAVunZss3a4sFiPqq92_C-FcmX4fiN2CALYZwcBlflaBNuO9JBlnwbXeSSsrEfLDsA"
        
        /*
        o365User.getCalendarInfo(refreshToken: accessToken) {
            (response) in
            // print(response!)
            availabilityResponse = response!
        }*/
        
        let data = ["name": o365User.accessToken, "age": "26"]
        return try req.view().render("leafTest", data)
    } */
    
    // Says hello
    /*router.get("hello", String.parameter) { req -> Future<View> in
        return try req.view().render("hello", [
            "name": req.parameters.next(String.self)
        ])
    }*/
}

struct outPut: Content {
    var text = "module initialized"
}
