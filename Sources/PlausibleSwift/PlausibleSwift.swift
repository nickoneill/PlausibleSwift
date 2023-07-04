import Foundation

/// PlausibleSwift is an implementation of the Plausible Analytics REST events API as described here: https://plausible.io/docs/events-api
public struct PlausibleSwift {
    public private(set) var domain = ""
    
    private let PlausibleAPIEventURL = URL(string: "https://plausible.io/api/event")!

    /// Initializes a plausible object used for sending events to Plausible.io
    /// Throws a `invalidDomain` error if the domain you pass cannot be turned into a URL
    /// - Parameters:
    ///     - domain: a fully qualified domain representing a site you have set up on plausible.io, such as `5calls.org`
    public init(domain: String) throws {
        // try to craft a URL out of our domain to ensure correctness
        guard let _ = URL(string: "https://\(domain)") else {
            throw PlausibleError.invalidDomain
        }
        
        self.domain = domain
    }
    
    /// Sends a pageview event to Plausible for the specified path
    /// - Parameters:
    ///     - path: a URL path to use as the pageview location (as if it was viewed on a website). There doesn't have to be anything served at this URL.
    /// Throws a `domainNotSet` error if it has been configured with an empty domain
    public func trackPageview(path: String) throws {
        guard self.domain != "" else {
            throw PlausibleError.domainNotSet
        }
        
        plausibleRequest(name: "pageview", path: path)
    }

    /// Sends a named event to Plausible for the specified path
    /// - Parameters:
    ///     - event: an arbitrary event name for your analytics.
    ///     - path: a URL path to use as the pageview location (as if it was viewed on a website). There doesn't have to be anything served at this URL.
    /// Throws a `domainNotSet` error if it has been configured with an empty domain.
    /// Throws a `eventIsPageview` error if you try to specific the event name as `pageview` which may indicate that you're holding it wrong.
    public func trackEvent(event: String, path: String) throws {
        guard event != "pageview" else {
            throw PlausibleError.eventIsPageview
        }
        
        plausibleRequest(name: event, path: path)
    }
    
    private func plausibleRequest(name: String, path: String) {
        var req = URLRequest(url: PlausibleAPIEventURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["name": name,"url": constructPageviewURL(path: path),"domain": domain])
        req.httpBody = jsonData
        
        URLSession.shared.dataTask(with: req) { data, response, err in
            if let err = err {
                var resString = ""
                if let data {
                  resString = String(data: data, encoding: .utf8) ?? ""
                }
                print("error sending pageview to Plausible: \(err): \(resString)")
            }
        }.resume()
    }
    
    internal func constructPageviewURL(path: String) -> String {
        let url = URL(string: "https://\(domain)")!

        // TODO: replace with iOS 16-only path methods at some point
        return url.appendingPathComponent(path).absoluteString
    }
}

public enum PlausibleError: Error {
    case domainNotSet
    case invalidDomain
    case eventIsPageview
}
