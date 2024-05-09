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
    
    let todayAgendaButton = ImageTextButton().then {
        $0.setImage(DesignSystemAsset.Home.bookRoundedRectangle.image)
        $0.setTitle("오늘의 아젠다")
        $0.setSubTitle("내 목표")
    }
    
    let growUpButton = ImageTextButton().then {
        $0.setImage(DesignSystemAsset.Home.sparkRoundedRectangle.image)
        $0.setTitle("성과 확인하기")
        $0.setSubTitle("성장일지")
    }
    
    let calendarVisibleButton = CalendarVisibleButton()
    
    let calendarView = CalendarView()
    
    let todayAgendaTitleBar = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    let todayAgendaCount = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "오늘의 아젠다 (?)"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        $0.textColor = UIColor(hex: "4E4C4C")
    }
    
    let trashButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Home.trash.image, for: .normal)
    }
    
    let todayAgendaBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(hex: "EBEBEB").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    let completedAgendaCount = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "완료된 아젠다 (?)"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        $0.textColor = UIColor(hex: "4E4C4C")
    }
    
    let completedAgendaBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(hex: "EBEBEB").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
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
        contentView.addSubview(calendarVisibleButton)
        contentView.addSubview(calendarView)
        contentView.addSubview(todayAgendaTitleBar)
        todayAgendaTitleBar.addArrangedSubview(todayAgendaCount)
        todayAgendaTitleBar.addArrangedSubview(trashButton)
        contentView.addSubview(todayAgendaBackgroundView)
        contentView.addSubview(completedAgendaCount)
        contentView.addSubview(completedAgendaBackgroundView)
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
        
        calendarVisibleButton.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(calendarVisibleButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(0)
        }
        
        todayAgendaTitleBar.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        trashButton.snp.makeConstraints {
            $0.width.height.equalTo(34)
        }
        
        todayAgendaBackgroundView.snp.makeConstraints {
            $0.top.equalTo(todayAgendaTitleBar.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        
        completedAgendaCount.snp.makeConstraints {
            $0.top.equalTo(todayAgendaBackgroundView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completedAgendaBackgroundView.snp.makeConstraints {
            $0.top.equalTo(completedAgendaCount.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        
    }
}

extension DemoHomeViewController: View {
    public func bind(reactor: DemoHomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        
        todayAgendaButton.button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("todayAgendaButton")
            }.disposed(by: disposeBag)
        
        growUpButton.button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("growUpButton")
            }.disposed(by: disposeBag)
        
        calendarVisibleButton.button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarVisibleButton.toggleCalendarVisible()
                
                UIView.animate(withDuration: 0.3) {
                    let newHeight = owner.calendarVisibleButton.isVisibleCalendar ? 200 : 0
                    owner.calendarView.snp.updateConstraints {
                        $0.height.equalTo(newHeight)
                    }
                    owner.view.layoutIfNeeded()
                }
                print("calendarVisibleButton -", owner.calendarVisibleButton.isVisibleCalendar)
            }).disposed(by: disposeBag)
        
    }
    
    private func bindAction(reactor: DemoHomeReactor) {
        
    }
    
    private func bindState(reactor: DemoHomeReactor) {
        
    }
    
}

private extension DemoHomeViewController {
    func updateMossiggang() {
      
    }
    
}
