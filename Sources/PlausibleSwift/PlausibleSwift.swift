import Foundation

/// PlausibleSwift is a
public struct PlausibleSwift {
    public private(set) var domain = ""
    
    private let PlausibleAPIEventURL = URL(string: "https://plausible.io/api/event")!

    /// Initializes a plausible object used for sending events to Plausible.io
    /// - Parameters:
    ///     - domain: a fully qualified domain representing a site you have set up on plausible.io, such as `5calls.org`
    public init(domain: String) throws {
        // try to craft a URL out of our domain to ensure correctness
        guard let _ = URL(string: "https://\(domain)") else {
            throw PlausibleError.invalidDomain
        }
        
        self.domain = domain
    }
    
    /// Sends a pageview event...
    /// Throws a `domainNotSet` error if it has been configured with an empty domain
    ///
    public func trackPageview(path: String) throws {
        guard self.domain != "" else {
            throw PlausibleError.domainNotSet
        }
        
        var req = URLRequest(url: PlausibleAPIEventURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["name":"pageview","url": constructPageviewURL(path: path),"domain": domain])
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
}
