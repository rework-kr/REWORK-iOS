import UIKit
import DesignSystem
import HomeFeature

public enum TabItemType {
    case home, achievement, myInfo
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .achievement:
            return "성과"
        case .myInfo:
            return "내 정보"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            DesignSystemAsset.Home.house.image
        case .achievement:
            DesignSystemAsset.Home.magazine.image
        case .myInfo:
            DesignSystemAsset.Home.personFill.image
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            HomeViewController()
        case .achievement:
            UIViewController().then { $0.view.backgroundColor = .green }
        case .myInfo:
            UIViewController().then { $0.view.backgroundColor = .white }
        }
    }
    
}
