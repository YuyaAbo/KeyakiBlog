import Foundation

class UserDefaultsClient {
    
    private enum Key: String {
        case firstLaunchedAt = "firstLaunchedAt"
        case lastLaunchedAt = "lastLaunchedAt"
        case launchedCount = "launchedCount"
        case recommendedIds = "recommendedIds"
    }
    
    private var memberID: Int = 0
    
    static func instantinate() -> UserDefaultsClient {
        let ud = UserDefaultsClient()
        
        return ud
    }
    
    static func instantinate(memberID: Int) -> UserDefaultsClient {
        let ud = UserDefaultsClient()
        ud.memberID = memberID
        
        return ud
    }
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    var firstLaunchedAt: NSDate? {
        set {
            defaults.set(newValue, forKey: Key.firstLaunchedAt.rawValue)
            defaults.synchronize()
        }
        get {
            guard let rawValue = defaults.object(forKey: Key.firstLaunchedAt.rawValue) as? NSDate else {
                return nil
            }
            return rawValue
        }
    }
    
    var lastLaunchedAt: NSDate? {
        set {
            defaults.set(newValue, forKey: Key.lastLaunchedAt.rawValue)
            defaults.synchronize()
        }
        get {
            guard let rawValue = defaults.object(forKey: Key.lastLaunchedAt.rawValue) as? NSDate else {
                return nil
            }
            return rawValue
        }
    }
    
    var launchedCount: Int? {
        set {
            defaults.set(newValue, forKey: Key.launchedCount.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.integer(forKey: Key.launchedCount.rawValue)
        }
    }
    
    var recommendedIds: [Int] {
        set {
            defaults.set(newValue, forKey: Key.recommendedIds.rawValue)
            defaults.synchronize()
        }
        get {
            guard let rawValue = defaults.array(forKey: Key.recommendedIds.rawValue) as? [Int] else {
                return [MemberList.ishimori.rawValue]
            }
            return rawValue
        }
    }

}
