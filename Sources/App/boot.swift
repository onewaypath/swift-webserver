import Vapor
import unixTools

var testHTML = ""


/// Called after your application has initialized.
public func boot(_ app: Application) throws {
   testHTML = unixTools().runUnix("cat", arguments: ["html-dev/testHTML.html"])
    // Your code here
}
