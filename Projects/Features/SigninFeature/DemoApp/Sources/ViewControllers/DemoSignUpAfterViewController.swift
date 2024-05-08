import UIKit
import DesignSystem
import BaseFeature
import SnapKit
import Then
import Utility
import RxSwift
import RxCocoa
import ReactorKit
import RxKeyboard

public class DemoSignUpAfterViewController: BaseViewController, UINavigationControllerDelegate {
    public var disposeBag = DisposeBag()
    
    let rocketImageView = UIImageView().then {
        $0.image = DesignSystemAsset.rework.image
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "222222")
        $0.text = "아래 이메일로 빠르게 컨텍 메일을 발송해드릴게요"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        $0.textAlignment = .center
    }
    
    let emailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "909090")
        $0.text = ""
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 11)
        $0.textAlignment = .center
    }
    
    let returnToLoginButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor(hex: "2D2D2D").cgColor
        $0.setTitle("로그인하러 가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    }
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        emailLabel.text = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setLayout()
        navigationController?.isNavigationBarHidden = true
        self.reactor = DemoSignUpAfterReactor()
        navigationController?.delegate = self
    }
}

extension DemoSignUpAfterViewController {
    func addSubViews() {
        self.view.addSubview(rocketImageView)
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailLabel)
        self.view.addSubview(returnToLoginButton)
    }
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        let stackViewHeight: CGFloat = 19 + 13 + 12 // titleLabel Height + emailLabel Height + spacing
        let contentViewHeight: CGFloat = APP_HEIGHT() - STATUS_BAR_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT()
        
        rocketImageView.snp.makeConstraints {
            let stackViewTop = (contentViewHeight / 2) - (stackViewHeight / 2)
            let centerY = stackViewTop / 2
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(stackView.snp.top).offset(-centerY)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        returnToLoginButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-30 - SAFEAREA_BOTTOM_HEIGHT())
        }
    }
}

extension DemoSignUpAfterViewController: View {
    public func bind(reactor: DemoSignUpAfterReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: DemoSignUpAfterReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        returnToLoginButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: DemoSignUpAfterReactor) {
    }
}
