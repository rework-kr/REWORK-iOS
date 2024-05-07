import UIKit
import DesignSystem
import BaseFeature
import SignInFeature
import SnapKit
import Then
import Utility
import RxSwift
import RxCocoa
import ReactorKit
import RxKeyboard

public class DemoSignUpViewController: BaseViewController {
    public var disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let logoImageView = UIImageView().then {
        $0.image = DesignSystemAsset.rework.image
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "222222")
        $0.text = "우리는 효율적으로 일하는 리워크입니다"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "222222")
        $0.text = "리워크는 업무 효율성을 위한 기록용 아카이빙 서비스를 제공하고 있어요\n소규모 회원을 위한 서비스 품질을 위해 폐쇄성 있는 서비스를 제공해요"
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 10)
        $0.textAlignment = .center

    }
    
    let emailTextField = UITextField().then {
        $0.keyboardType = .emailAddress
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.attributedPlaceholder = NSAttributedString(
            string: "계정 정보를 입력해주세요",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 10),
                .foregroundColor: UIColor(hex: "B2BBC3")
            ]
        )
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "DEDEDE").cgColor
        $0.horizontalPadding(10)
    }
    
    let signupButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor(hex: "2D2D2D").cgColor
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
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
        self.reactor = DemoSignUpReactor()
        reactor?.action.onNext(.viewDidLoad)
        emailTextField.delegate = self
    }
}

extension DemoSignUpViewController {
    func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(signupButton)
    }
    
    func setLayout() {
        let contentViewHeight: CGFloat = APP_HEIGHT() - STATUS_BAR_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT()
        self.view.backgroundColor = .white

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
        
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-15)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(emailTextField.snp.top).offset(-30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        signupButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

extension DemoSignUpViewController: View {
    public func bind(reactor: DemoSignUpReactor) {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { Reactor.Action.keyboardWillShow($0.height) }

        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in Reactor.Action.keyboardWillHide }
        
        Observable.merge(keyboardWillShow, keyboardWillHide)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.keyboardHeight)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                owner.updateViewInsetForKeyboardHeight(keyboardHeight)
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validationResult }
            .map { return $0 == .ok ? true : false }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, emailIsValid in
                owner.updateSignUpButtonState(emailIsValid)
            }).disposed(by: disposeBag)
        
    }
    
}

private extension DemoSignUpViewController {
    func updateViewInsetForKeyboardHeight(_ keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self?.scrollView.contentInset = contentInset
            self?.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    func updateSignUpButtonState(_ isEnabled: Bool) {
        signupButton.isEnabled = isEnabled
        signupButton.layer.backgroundColor = isEnabled ?
        UIColor(hex: "2D2D2D").cgColor : UIColor.gray.cgColor
    }
}

extension DemoSignUpViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

