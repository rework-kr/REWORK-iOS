import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AuthDomain
import BaseFeature
import HomeFeature
import DesignSystem
import Utility

public final class MainTabViewController: BaseReactorViewController<MainTabReactor>, ContainerViewType {
    var contentView = UIView()
    let tabBarBacgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner ]
    }
    let tabBarView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 50
        $0.distribution = .equalSpacing
    }
    let tabItems: [TabItemView] = [
        TabItemView(tabItemType: .home),
        TabItemView(tabItemType: .achievement),
        TabItemView(tabItemType: .myInfo)
    ]
    let safeAreaBottomView = UIView().then {
        $0.backgroundColor = .black
    }
    
    var currentViewController: UIViewController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setLayout()
        switchToViewController(.home)
    }
    
    override public func addView() {
        self.view.backgroundColor = .white
        self.view.addSubview(contentView)
        self.view.addSubview(tabBarBacgroundView)
        tabBarBacgroundView.addSubview(tabBarView)
        tabItems.forEach {
            tabBarView.addArrangedSubview($0)
            $0.delegate = self
        }
        self.view.addSubview(safeAreaBottomView)
    }
    
    override public func setLayout() {
        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        tabBarBacgroundView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaBottomView.snp.top)
        }
        tabBarView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        tabItems.forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(56)
            }
        }
        safeAreaBottomView.snp.makeConstraints {
            $0.height.equalTo(SAFEAREA_BOTTOM_HEIGHT())
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    public override func bindState(reactor: MainTabReactor) {
        
    }
    
    public override func bindAction(reactor: MainTabReactor) {
        
    }
}

extension MainTabViewController: TabItemDelegate {
    public func tabItemDidTap(tabItemType: TabItemType) {
        print("tabItemDidTap:", tabItemType.title)
        //switchToViewController(tabItemType)
        NotificationCenter.default.post(name: .loginStateDidChanged, object: false)
    }
    
    private func switchToViewController(_ tabItemType: TabItemType) {
        remove(asChildViewController: currentViewController)
        add(asChildViewController: tabItemType.viewController)
        currentViewController = tabItemType.viewController
    }
}
