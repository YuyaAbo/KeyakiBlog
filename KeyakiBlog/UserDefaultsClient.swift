import Foundation

class UserDefaultsClient {
    
    private enum Key: String {
        case follow = "isFollowed"
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
    
    var memberIsFollowed: Bool {
        set {
            defaults.set(newValue, forKey: "\(memberID)" + Key.follow.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.bool(forKey: "\(memberID)" + Key.follow.rawValue)
        }
    }

}
