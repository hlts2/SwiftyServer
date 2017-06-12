import Foundation

public class RouterManager {
    
    public var routers = [Router]()
    
    public func addRouter(router: Router) {
        routers.append(router)
    }
    
    public func searchRouter(path: String) -> Router? {
        
        for router in routers {
            if path.pregMatch(pattern: router.path) {
                return router
            }
        }
        
        return nil
    }
}
