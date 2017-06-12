import Foundation

open class HTTPClient {
    
    public var request: Request
    internal(set) public var sock: TCPSocketClient
    
    public init(fd: Int32) {
        self.sock = TCPSocket(fd: fd)
        
        let data = self.sock.read()
        request = HttpRequest(header: String(data: data, encoding: .utf8)!)
    }
}
