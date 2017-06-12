import Foundation

public protocol ResponseWriter {
    func write(_ message: String)
    func writeNotFound()
}

class HttpResponse: ResponseWriter {
    
    private var sock: TCPSocketClient
    var type: Type!
    var status: HTTPStatus!
    
    init(sock: TCPSocketClient) {
        self.sock = sock
    }
    
    enum `Type`: String {
        case text   = "text/plain"
        case html   = "text/html"
        case css    = "text/css"
        case js     = "text/javascript"
        case png    = "image/png"
        case gif    = "image/gif"
        case json   = "application/json"
    }
    
    enum HTTPStatus: Int {
        case ok       = 200
        case notFound = 404
        
        func description() -> String {
            switch self {
            case .ok:
                return "200 OK"
            case .notFound:
                return "404 Not Found"
            }
        }
    }
    
    var header: String {
        get {
            return "HTTP/1.0 \(status.description())\nTransfer-Encoding:chunked\nContent-Type:\(type.rawValue); charset=utf-8\n\n"
        }
    }
    
    func setHeader(_ status: HTTPStatus, _ type: Type) {
        self.status = status
        self.type = type
    }
    
    public func writeNotFound() {
        setHeader(.notFound, .html)
        write(header)
        write("<html><body>Not Found</body></html>")
    }
    
    public func write(_ message: String) {
        
        if status == nil && type == nil {
            setHeader(.ok, parseBody(message: message))
            self.sock.write(message: header)
        }
        
        self.sock.write(message: message)
    }
    
    private func parseBody(message: String) -> Type {
        
        if message.pregMatch(pattern: "<html>|<head>|<body>|<h1>|<a.*>") {
            return .html
        }
        
        return .text
    }
    
    func writeEnd() {
        sock.close()
    }
}
