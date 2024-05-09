import UIKit
import DesignSystem
import BaseFeature
import HomeFeature
import SnapKit
import Then
import Utility
import RxSwift
import RxCocoa
import ReactorKit
import RxKeyboard

public class DemoHomeViewController: BaseViewController {
    public var disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 25
    }
    
    let todayAgendaButton = UIButton().then {
        $0.addSubview(ImageTextView.makeUIView(subTitle: "내 목표", title: "오늘의 아젠다"))
    }
    
    let growUpButton = UIButton().then {
        $0.addSubview(ImageTextView.makeUIView(subTitle: "성장일지", title: "성과 확인하기"))
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        addSubViews()
        setLayout()
        hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        self.reactor = DemoHomeReactor()
    }
}

extension DemoHomeViewController {
    func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(hStackView)
        hStackView.addArrangedSubview(todayAgendaButton)
        hStackView.addArrangedSubview(growUpButton)
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        let contentViewHeight: CGFloat = APP_HEIGHT() - STATUS_BAR_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT()
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(STATUS_BAR_HEIGHT())
            $0.height.equalTo(contentViewHeight)
            $0.bottom.equalToSuperview().offset(-SAFEAREA_BOTTOM_HEIGHT())
        }
        
        contentView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        todayAgendaButton.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(40)
        }
        
        growUpButton.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(40)
        }
        
        
        
        
    }
}

extension DemoHomeViewController: View {
    public func bind(reactor: DemoHomeReactor) {
       
        
    }
    
}

private extension DemoHomeViewController {
    func updateMossiggang() {
      
    }
    
}
