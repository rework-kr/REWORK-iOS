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

let testTodayAgendaList = ["주간회의 업무 보고", "컨퍼런스 미팅", "컨퍼런스 연사 준비", "외부 밋업 초청 컨택", "기술 블로그 작성하기", "세미나 개최하기"]

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
    
    let addButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Home.plusCircle.image, for: .normal)
        $0.layer.shadowOffset = .zero
        $0.layer.shadowOpacity = 0.25
    }
    
    let todayAgendaTableView = UITableView().then {
        $0.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.reuseIdentifier)
        $0.layer.borderColor = UIColor(hex: "EBEBEB").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.separatorInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        //$0.separatorStyle = .none
    }
    
    lazy var todayAgendaTableViewDiffableDataSource = UITableViewDiffableDataSource<Int, AgendaSectionItem>(
        tableView: todayAgendaTableView
    ) { tableView, indexPath, itemIdentifier in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell
        else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title)
        cell.selectionStyle = .none
        return cell
    }
    
    let completedAgendaCount = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "완료된 아젠다 (?)"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        $0.textColor = UIColor(hex: "4E4C4C")
    }
    
    let completedAgendaTableView = UITableView().then {
        $0.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.reuseIdentifier)
        $0.layer.borderColor = UIColor(hex: "EBEBEB").cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.separatorInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        //$0.separatorStyle = .none
    }
    
    lazy var completedAgendaTableViewDiffableDataSource = UITableViewDiffableDataSource<Int, AgendaSectionItem>(
        tableView: completedAgendaTableView
    ) { tableView, indexPath, itemIdentifier in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell
        else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title)
        cell.selectionStyle = .none
        return cell
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
        self.reactor = DemoHomeReactor()
        
        hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        
        todayAgendaTableView.delegate = self
        setTodayAgendaTableView()
        setCompletedAgendaTableView()
    }
    
    func setTodayAgendaTableView() {
        let todayAgendaList = testTodayAgendaList
            .enumerated()
            .map { AgendaSectionItem(index: $0.offset, title: $0.element) }
        var snapshot = todayAgendaTableViewDiffableDataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(todayAgendaList, toSection: 0)
        
        todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setCompletedAgendaTableView() {
        var snapshot = completedAgendaTableViewDiffableDataSource.snapshot()
        snapshot.appendSections([0])
        
        completedAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
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
        todayAgendaTitleBar.addArrangedSubview(addButton)
        contentView.addSubview(todayAgendaTableView)
        contentView.addSubview(completedAgendaCount)
        contentView.addSubview(completedAgendaTableView)
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
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(34)
        }
        
        todayAgendaTableView.snp.makeConstraints {
            $0.top.equalTo(todayAgendaTitleBar.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        
        completedAgendaCount.snp.makeConstraints {
            $0.top.equalTo(todayAgendaTableView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completedAgendaTableView.snp.makeConstraints {
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

extension DemoHomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
