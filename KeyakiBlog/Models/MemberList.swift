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
    
    // enumの要素を回すため
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
            return #imageLiteral(resourceName: "ishimori")
        case .imaizumi:
            return #imageLiteral(resourceName: "imaizumi")
        case .uemura:
            return #imageLiteral(resourceName: "uemura")
        case .ozeki:
            return #imageLiteral(resourceName: "ozeki")
        case .oda:
            return #imageLiteral(resourceName: "oda")
        case .koike:
            return #imageLiteral(resourceName: "koike")
        case .kobayashi:
            return #imageLiteral(resourceName: "kobayashi")
        case .saito:
            return #imageLiteral(resourceName: "saito")
        case .sato:
            return #imageLiteral(resourceName: "sato")
        case .shida:
            return #imageLiteral(resourceName: "shida")
        case .sugai:
            return #imageLiteral(resourceName: "sugai")
        case .suzumoto:
            return #imageLiteral(resourceName: "suzumoto")
        case .nagasawa:
            return #imageLiteral(resourceName: "nagasawa")
        case .habu:
            return #imageLiteral(resourceName: "habu")
        case .harada:
            return #imageLiteral(resourceName: "harada")
        case .hirate:
            return #imageLiteral(resourceName: "hirate")
        case .moriya:
            return #imageLiteral(resourceName: "moriya")
        case .yonetani:
            return #imageLiteral(resourceName: "yonetani")
        case .berika:
            return #imageLiteral(resourceName: "rika")
        case .berisa:
            return #imageLiteral(resourceName: "risa")
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
