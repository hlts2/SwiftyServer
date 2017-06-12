import Foundation

public enum HTTPServerResult {
    case success
    case failure(Error)
    
    public init(_ error: Error) {
        self = .failure(error)
    }
}
