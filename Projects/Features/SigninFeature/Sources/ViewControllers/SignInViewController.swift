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

public class SignInViewController: BaseViewController {
    public var disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let logoImageView = UIImageView().then {
        $0.image = DesignSystemAsset.SignIn.rework.image
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    let accountTextField = UITextField().then {
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
        $0.alpha = 0
    }
    
    let passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
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
        $0.alpha = 0
    }
    
    let signupButton = UIButton().then {
        $0.setTitle(" 회원 가입 | 리워크가 처음이신가요? 이메일을 통해 컨택 메일을 드릴게요", for: .normal)
        $0.setTitleColor(UIColor(hex: "B2BBC3"), for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 10)
    }
    
    let loginButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor(hex: "2D2D2D").cgColor
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    }
    
    public init() {
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
        self.reactor = SignInReactor()
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension SignInViewController {
    func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(accountTextField)
        stackView.addArrangedSubview(passwordTextField)
        contentView.addSubview(signupButton)
        contentView.addSubview(loginButton)
    }
    
    func setLayout() {
        let stackViewHeight: CGFloat = 120 // accountTextField Height(50) + passwordTextField Height(50) + spacing(20)
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
            let stackViewTop = (contentViewHeight / 2) - (stackViewHeight / 2)
            let centerY = stackViewTop / 2
            $0.centerY.equalTo(stackView.snp.top).offset(-centerY)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.centerY.equalToSuperview()
        }
        
        accountTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints {
            $0.bottom.equalTo(self.loginButton.snp.top).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

extension SignInViewController: View {
    public func bind(reactor: SignInReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SignInReactor) {
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
        
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        accountTextField.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let signUpViewController = SignUpViewController()
                owner.navigationController?.pushViewController(signUpViewController, animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindState(reactor: SignInReactor) {
        reactor.state.map(\.viewDidLoaded)
            .withUnretained(self)
            .subscribe(onNext: { owner, viewDidLoaded in
                owner.updateAccountTextFieldAlpha()
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.keyboardHeight)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                owner.updateViewInsetForKeyboardHeight(keyboardHeight)
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.validationResult)
            .map { return $0 == .ok ? true : false }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, emailIsValid in
                owner.updateLoginButtonState(emailIsValid)
                owner.updatePasswordTextFieldState(emailIsValid)
            }).disposed(by: disposeBag)
        
        reactor.pulse(\.$loggedIn)
            .compactMap { $0 }
            .bind(with: self) { owner, isLoggedIn in
                print("로그인 버튼 눌림", isLoggedIn)
            }
            .disposed(by: disposeBag)
    }
    
}

private extension SignInViewController {
    func updateAccountTextFieldAlpha() {
        UIView.animate(withDuration: 1.5) { [weak self] in
            self?.accountTextField.alpha = 1
        }
    }
    
    func updateViewInsetForKeyboardHeight(_ keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self?.scrollView.contentInset = contentInset
            self?.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    func updateLoginButtonState(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.layer.backgroundColor = isEnabled ?
        UIColor(hex: "2D2D2D").cgColor : UIColor.gray.cgColor
    }
    
    func updatePasswordTextFieldState(_ isEnabled: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.passwordTextField.alpha = isEnabled ? CGFloat(1.0) : CGFloat(0)
            self?.passwordTextField.transform = isEnabled ?
            CGAffineTransform(translationX: 0, y: 0)
            : CGAffineTransform(translationX: 0, y: 20)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField && reactor?.currentState.validationResult == .ok {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

