import Foundation

public class Router {
    
    public var path: String
    public var handler: Handler
    
    public init(_ path: String, _ handler: @escaping Handler) {
        self.path = path
        self.handler = handler
    }
}
