import XCTest
@testable import PlausibleSwift

final class PlausibleSwiftTests: XCTestCase {
    func testInitWithDomain() {
        do {
            _ = try PlausibleSwift(domain: "5calls.org")
        } catch {
            assertionFailure("failed to create a plausible object with a domain")
        }
    }
    
    func testInvalidDomain() {
        do {
            _ = try PlausibleSwift(domain: "5calls")
        } catch let err as PlausibleError {
            assert(err == PlausibleError.invalidDomain, "domain should be invalid")
        } catch {
            assertionFailure("some other unknown error while init with a bad domain")
        }
    }
    
    func testSinglePathConstruction() {
        let plausible = try! PlausibleSwift(domain: "5calls.org")
        
        let urlString = plausible.constructPageviewURL(path: "/")
        assert(urlString == "https://5calls.org/", "pageview url was \(urlString)")
    }

    func testMultiplePathConstruction() {
        let plausible = try! PlausibleSwift(domain: "5calls.org")
        
        let urlString = plausible.constructPageviewURL(path: "/issue/dont-ban-tiktok")
        assert(urlString == "https://5calls.org/issue/dont-ban-tiktok", "pageview url was \(urlString)")
    }

    func testNoSlashPathConstruction() {
        let plausible = try! PlausibleSwift(domain: "5calls.org")
        
        let urlString = plausible.constructPageviewURL(path: "all")
        assert(urlString == "https://5calls.org/all", "pageview url was \(urlString)")
    }
}
