import Foundation

internal extension String {
    
    func pregMatch(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        if let _ = regex.firstMatch(in: self, range: NSMakeRange(0, self.characters.count)) {
            return true
        } else {
            return false
        }
    }
    
    func pregReplace(pattern: String, with: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.stringByReplacingMatches(in: self, range: NSMakeRange(0, self.characters.count), withTemplate: with)
    }
}
