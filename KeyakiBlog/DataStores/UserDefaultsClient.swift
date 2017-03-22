import Foundation

class UserDefaultsClient {
    
    private enum Key: String {
        case recommend = "isRecommended"
    }
    
    private var memberID: Int = 0
    
    static func instantinate(memberID: Int) -> UserDefaultsClient {
        let ud = UserDefaultsClient()
        ud.memberID = memberID
        
        return ud
    }
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    var memberIsRecommended: Bool {
        set {
            defaults.set(newValue, forKey: "\(memberID)" + Key.recommend.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.bool(forKey: "\(memberID)" + Key.recommend.rawValue)
        }
    }

}
