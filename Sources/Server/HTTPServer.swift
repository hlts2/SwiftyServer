import Foundation

public typealias Handler = (_ w: ResponseWriter, _ r: Request) -> ()


open class HTTPServer {

    private var sock: TCPSocketServer = TCPSocket()
    private var routerMng: RouterManager = RouterManager()

    enum HttpMethod {
        case GET
        case POST
    }
    
    private init() {}
    
    public static let instance: HTTPServer = HTTPServer()
    
    open func serveHTTP(port: Int) throws {
        
        defer {
            self.sock.close()
        }
        
        try self.sock.bind(port: port)
        try self.sock.listen()
        
        while true {
            try self.sock.accept() { client in
                self.handleRequest(response: HttpResponse(sock: client.sock), request: client.request)
            }
        }
    }
    
    private func handleRequest(response: HttpResponse, request: Request) {
        
        if let router = routerMng.searchRouter(path: request.path) {
            router.handler(response, request)
            response.writeEnd()
        } else {
            response.writeNotFound()
            response.writeEnd()
        }
    }
    
    open func get(_ path: String, _ handler: @escaping Handler) {
        //TODO: HttpMethodを追加
        routerMng.addRouter(router: Router("^" + path + "$", handler))
    }
    
    open func all(_ path: String, _ handler: @escaping Handler) {
        routerMng.addRouter(router: Router("^" + path + ".*", handler))
    }
}
