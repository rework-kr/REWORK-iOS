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
import NVActivityIndicatorView

public class DemoSignUpViewController: BaseViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    public var disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let customNavigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.arrowBack.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = UIColor(hex: "222222")
    }
    
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
    
    lazy var loadingBackgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isHidden = true
    }
    
    lazy var activityIndicator = NVActivityIndicatorView(
        frame: .init(x: 0, y: 0, width: 50, height: 50))
        .then {
        $0.type = .ballPulseSync
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("회원가입뷰 ViewDidLoad")
        addSubViews()
        setLayout()
        hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        self.reactor = DemoSignUpReactor()
        emailTextField.delegate = self
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        self.view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(backButton)
        self.view.addSubview(loadingBackgroundView)
        loadingBackgroundView.addSubview(activityIndicator)
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
        
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(STATUS_BAR_HEIGHT())
            $0.horizontalEdges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        loadingBackgroundView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

extension DemoSignUpViewController: View {
    public func bind(reactor: DemoSignUpReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        
        backButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: DemoSignUpReactor) {
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
        
        emailTextField.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .map { Reactor.Action.signUpButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: DemoSignUpReactor) {
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
                owner.updateSignUpButtonState(emailIsValid)
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.signUpState)
            .filter { $0 == true }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, state in
                let email = owner.emailTextField.text
                owner.showSignUpAfterViewController(email: email ?? "")
            }.disposed(by: disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isLoading in
                print("🚀isLoading:", isLoading)
                owner.loadingViewIsAppear(isLoading)
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
    
    func showSignUpAfterViewController(email: String) {
        let signUpAfterViewController = DemoSignUpAfterViewController(email: email)
        navigationController?.pushViewController(signUpAfterViewController, animated: true)
    }
    
    func loadingViewIsAppear(_ isLoading: Bool) {
        if isLoading {
            loadingBackgroundView.isHidden = false
            activityIndicator.startAnimating()
        } else {
            loadingBackgroundView.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}

extension DemoSignUpViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
