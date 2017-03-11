import UIKit

enum MemberList: Int {
    case ishimori
    case imaizumi
    case uemura
    case ozeki
    case oda
    case koike
    case kobayashi
    case saito
    case sato
    case shida
    case sugai
    case suzumoto
    case nagasawa
    case habu
    case harada
    case hirate
    case moriya
    case yonetani
    case berika
    case berisa
    
    static var enumerate: AnySequence<MemberList> {
        return AnySequence { () -> AnyIterator<MemberList> in
            var i = 0
            return AnyIterator { () -> MemberList? in
                let memberList = MemberList(rawValue: i)
                i = i + 1
                return memberList
            }
        }
    }
    
    var image: UIImage {
        switch self {
        case .ishimori:
            return #imageLiteral(resourceName: "Ishimori")
        case .imaizumi:
            return #imageLiteral(resourceName: "Imaizumi")
        case .uemura:
            return #imageLiteral(resourceName: "Uemura")
        case .ozeki:
            return #imageLiteral(resourceName: "Ozeki")
        default:
            return #imageLiteral(resourceName: "Ishimori")
        }
    }
    
    var articlePath: String {
        switch self {
        case .ishimori:
            return "01"
        case .imaizumi:
            return "02"
        case .uemura:
            return "03"
        case .ozeki:
            return "04"
        case .oda:
            return "05"
        case .koike:
            return "06"
        case .kobayashi:
            return "07"
        case .saito:
            return "08"
        case .sato:
            return "09"
        case .shida:
            return "10"
        case .sugai:
            return "11"
        case .suzumoto:
            return "12"
        case .nagasawa:
            return "13"
        case .habu:
            return "14"
        case .harada:
            return "15"
        case .hirate:
            return "17"
        case .moriya:
            return "18"
        case .yonetani:
            return "19"
        case .berika:
            return "20"
        case .berisa:
            return "21"
        }
    }
}
