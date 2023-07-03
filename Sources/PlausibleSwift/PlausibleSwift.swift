public struct PlausibleSwift {
    public private(set) var domain = ""

    public init(domain: String) {
        self.domain = domain
    }
    
    public func trackPageview(path: String) {
        
    }
}
