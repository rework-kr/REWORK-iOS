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
    
    lazy var completedAgendaTableViewDiffableDataSource = AgendaDataSource(
        tableView: completedAgendaTableView
    ) { tableView, indexPath, itemIdentifier in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell
        else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title)
        cell.selectionStyle = .none
        return cell
    }
    
    private let calendarViewHeight: CGFloat = 200
    
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
        configureTodayAgendaTableView()
        configureCompletedAgendaTableView()
        todayAgendaTableView.setEditing(true, animated: true)
    }
    
    func configureTodayAgendaTableView() {
        let todayAgendaList = testTodayAgendaList
            .enumerated()
            .map { AgendaSectionItem(title: $0.element) }
        var snapshot = todayAgendaTableViewDiffableDataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(todayAgendaList, toSection: 0)
        
        todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureCompletedAgendaTableView() {
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
                let isVisible = owner.calendarVisibleButton.isVisibleCalendar
                owner.updateCalendarVisibility(isVisible)
                print("calendarVisibleButton -", owner.calendarVisibleButton.isVisibleCalendar)
            }).disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var snapshot = owner.todayAgendaTableViewDiffableDataSource.snapshot()
                
                if let first = snapshot.itemIdentifiers.first {
                    snapshot.insertItems([AgendaSectionItem(title: "")], beforeItem: first)
                } else {
                    snapshot.appendItems([AgendaSectionItem(title: "")])
                }
                
                owner.todayAgendaTableViewDiffableDataSource.apply(snapshot)
                owner.todayAgendaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
            }.disposed(by: disposeBag)
        
    }
    
    private func bindAction(reactor: DemoHomeReactor) {
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
    }
    
    private func bindState(reactor: DemoHomeReactor) {
        reactor.state.map(\.keyboardState)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, state in
                owner.updateViewInsetForKeyboardState(state.isShow, state.height)
            }).disposed(by: disposeBag)
    }
    
}

private extension DemoHomeViewController {
    func updateViewInsetForKeyboardState(_ isShowKeyboard: Bool, _ keyboardHeight: CGFloat) {
        print("updateViewInsetForKeyboardHeight")
        let isVisibleCalendar = self.calendarVisibleButton.isVisibleCalendar
        var newInset = UIEdgeInsets()
        
        if isVisibleCalendar {
            // 캘린더가 보여지고 있을 때, 키보드가 나타나면 (캘린더 높이 + 키보드 높이) 키보드가 사라지면 (캘린더 높이)
            let newBottomInset = isShowKeyboard ? calendarViewHeight + keyboardHeight : calendarViewHeight
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(newBottomInset), right: 0)
        } else {
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.scrollView.contentInset = newInset
            self.scrollView.scrollIndicatorInsets = newInset
        }
    }
    
    func updateCalendarVisibility(_ isVisible: Bool) {
        print("updateCalendarVisibility")
        let newCalendarHeight: CGFloat = isVisible ? self.calendarViewHeight : 0
        let newContentInset: UIEdgeInsets = isVisible ? UIEdgeInsets(top: 0, left: 0, bottom: calendarViewHeight, right: 0) : .zero
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.calendarView.snp.updateConstraints {
                $0.height.equalTo(newCalendarHeight)
            }
            
            self.scrollView.contentInset = newContentInset
            self.scrollView.scrollIndicatorInsets = newContentInset
            
            self.view.layoutIfNeeded()
        }
    }
    
    func updateMossiggang() {
      
    }
    
}

extension DemoHomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }

    public func tableView(_ tableView: UITableView, dragIndicatorViewForRowAt indexPath: IndexPath) -> UIView? {
        // 편집모드 시 나타나는 오른쪽 Drag Indicator를 변경합니다.
        let dragIndicatorView = UIImageView(image: DesignSystemAsset.Home.dragIndicator.image)
        dragIndicatorView.frame = .init(x: 0, y: 0, width: 18, height: 18)
        return dragIndicatorView
    }
    
}

class AgendaDataSource: UITableViewDiffableDataSource<Int, AgendaSectionItem> {
    public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // 모든 Cell 을 이동 가능하게 설정합니다.
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let fromItem = itemIdentifier(for: sourceIndexPath),
              let toItem = itemIdentifier(for: destinationIndexPath),
              sourceIndexPath != destinationIndexPath else { return }
        
        var snapshot = snapshot()
        snapshot.deleteItems([fromItem])
        
        if destinationIndexPath.row > sourceIndexPath.row {
            snapshot.insertItems([fromItem], afterItem: toItem)
        } else {
            snapshot.insertItems([fromItem], beforeItem: toItem)
        }
        
        apply(snapshot, animatingDifferences: false)
    }
}
