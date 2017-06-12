import Foundation

class FileIO {
    
    class func FileOrDirExist(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func IsDirectory(_ path: String) -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    class func GetDirFiles(_ path: String) -> [String]? {
        return try? FileManager.default.contentsOfDirectory(atPath: path)
    }
}
