import Foundation

public protocol TCPSocketClient {
    func read() -> Data
    func write(message: String)
    func close()
}

public protocol TCPSocketServer {
    func bind(port: Int) throws
    func listen() throws
    func accept(_ callBack: @escaping (_ client: HTTPClient) -> ()) throws
    func close()
}

class TCPSocket: TCPSocketServer, TCPSocketClient {
    private var fd: Int32
    
    init() {
        fd = socket(AF_INET, SOCK_STREAM, 0)
    }
    
    init(fd: Int32) {
        self.fd = fd
    }
    
    func bind(port: Int) throws {
        var flg: Int32 = 1
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &flg, socklen_t(MemoryLayout<Int32>.size))
        
        var addrIn = sockaddr_in()
        addrIn.sin_family = UInt8(AF_INET)
        addrIn.sin_port = UInt16(port).bigEndian
        
        let err = withUnsafePointer(to: &addrIn) { addrInPtr in
            addrInPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { addrPtr in
                Darwin.bind(self.fd, addrPtr, UInt32(MemoryLayout<sockaddr_in>.stride))
            }
        }
        
        if err < 0 {
            throw SocketError.bindError
        }
    }
    
    func listen() throws {
        let err = Darwin.listen(fd, 5)
        
        if err < 0 {
            throw SocketError.listenError
        }
    }
    
    func accept(_ callBack: @escaping (_ client: HTTPClient) -> ()) throws {
        var addr = sockaddr()
        var len: socklen_t = 0
        
        let newFd = Darwin.accept(fd, &addr, &len)
        
        if newFd < 0 {
            throw SocketError.acceptError
        }
        
        DispatchQueue(label: "SwiftySocket.jp").async {
            callBack(HTTPClient(fd: newFd))
        }
    }
    
    func read() -> Data {
        var buf = [UInt8](repeating: 0, count: 1024)
        _ = Darwin.read(fd, &buf, 1024)
        
        return NSData(bytes: &buf, length: buf.count) as Data
    }
    
    func write(message: String) {
        var byteMsg: [UInt8] = Array(message.utf8)
        _ = Darwin.write(fd, &byteMsg, byteMsg.count)
    }
    
    func close() {
        _ = Darwin.close(fd)
    }
}
