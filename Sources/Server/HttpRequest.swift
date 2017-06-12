import Foundation

public protocol Request {
    var method: String { get }
    var path: String { get }
    var params: [String: String] { get }
    func stripPrefix(_ pattern: String, with: String) -> Request
}

class HttpRequest: Request {
    
    var method: String = ""
    var path: String = ""
    var params: [String: String] = [String: String]()
    
    init(header: String) {
        headerParse(header: header)
    }
    
    private func headerParse(header: String) {
        let headerElm = header.components(separatedBy: "\r\n")
        
        if headerElm.count > 0 {
            let firstLineElm = headerElm[0].components(separatedBy: " ")
            
            if firstLineElm.count > 0 {
                method = firstLineElm[0]
            }
            
            if firstLineElm.count > 1 {
                let url = firstLineElm[1]
                let urlElm = url.components(separatedBy: "?")
                
                if urlElm.count == 2 {
                    let path = urlElm[1]
                    let paramsElm = path.components(separatedBy: "&")
                    
                    self.path = path
                    
                    for param in paramsElm {
                        let args = param.components(separatedBy: "=")
                        
                        if args.count == 2 {
                            params["\(args[0])"] = args[1]
                        }
                    }
                } else {
                    self.path = urlElm[0]
                }
            }
        }
    }
    
    func stripPrefix(_ pattern: String, with: String) -> Request {
        self.path = self.path.pregReplace(pattern: pattern, with: "/" + with + "/")
        return self
    }
}
