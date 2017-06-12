import Foundation

public func StripPrefex(_ pattern: String, _ handler: @escaping Handler) -> Handler {
    return { response, request in
        
        let httpRequest = (request as! HttpRequest)
        httpRequest.path = httpRequest.path.pregReplace(pattern: pattern, with: "")
        handler(response, httpRequest)
    }
}

public func StaticFileServer(dirPath: String) -> Handler {
    
    return { response, request in
        
        let path = dirPath + request.path
        
        if FileIO.FileOrDirExist(path) {
            if FileIO.IsDirectory(path) {
                if let files = FileIO.GetDirFiles(path) {
                    for file in files {
                        response.write("<pre><a href=\"" +  file  + "\">" + file + "</a></pre>")
                    }
                }
            } else {
                
                //TODO:　別の書き方に変える
                let text = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                response.write(text as String)
            }
        } else {
            response.writeNotFound()
        }
    }
}
