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

let testTodayAgendaList = ["주간회의 업무 보고", "컨퍼런스 미팅", "컨퍼런스 연사 준비", "외부 밋업 초청 컨택", "기술 블로그 작성하기", "세미나 개최하기"]

public class HomeViewController: BaseReactorViewController<HomeReactor> {
    let homeView = HomeView()
    
    public override func loadView() {
        self.view = homeView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setDelegate()
        hideKeyboardWhenTappedAround()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    public override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func configureUI() {
        homeView.todayAgendaTableView.isEditing = true
    }
    
    private func setDelegate() {
        homeView.calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        homeView.todayAgendaTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        homeView.completedAgendaTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        homeView.agendaCellDelegate = self
    }
    
    public override func bindState(reactor: HomeReactor) {
        reactor.state.map(\.isVisibleCalendar)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isVisibleCalendar in
                owner.homeView.calendarVisibleButton.toggleCalendarVisible()
                owner.updateCalendarVisibility(isVisibleCalendar)
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.uncompletedAgendaDataSource)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, dataSource in
                var snapshot = owner.homeView.todayAgendaTableViewDiffableDataSource.snapshot()
                
                let sectionIdentifier = 0
                if !snapshot.sectionIdentifiers.contains(sectionIdentifier) {
                    snapshot.appendSections([sectionIdentifier])
                }
                snapshot.appendItems(dataSource, toSection: 0)
                
                owner.homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.completedAgendaDataSource)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, dataSource in
                var snapshot = owner.homeView.completedAgendaTableViewDiffableDataSource.snapshot()
                
                let sectionIdentifier = 0
                if !snapshot.sectionIdentifiers.contains(sectionIdentifier) {
                    snapshot.appendSections([sectionIdentifier])
                }
                snapshot.appendItems(dataSource, toSection: 0)
                
                owner.homeView.completedAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        reactor.state.map(\.keyboardState)
            .distinctUntilChanged()
            .bind(with: self) { owner, state in
                owner.updateViewInsetForKeyboardState(state.isShow, state.height)
                owner.homeView.todayAgendaTableView.setEditing(!state.isShow, animated: false)
            }.disposed(by: disposeBag)
        
    }
    
    public override func bindAction(reactor: HomeReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        homeView.todayAgendaButton.button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("todayAgendaButton")
            }.disposed(by: disposeBag)
        
        homeView.growUpButton.button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("growUpButton")
            }.disposed(by: disposeBag)
        
        homeView.calendarVisibleButton.button.rx.tap
            .map { _ in Reactor.Action.calendarVisibleButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeView.addButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var snapshot = owner.homeView.todayAgendaTableViewDiffableDataSource.snapshot()
                
                if let first = snapshot.itemIdentifiers.first {
                    snapshot.insertItems([AgendaSectionItem(title: "")], beforeItem: first)
                } else {
                    snapshot.appendItems([AgendaSectionItem(title: "")])
                }
                
                owner.homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot)
                owner.homeView.todayAgendaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
                if let cell = owner.homeView.todayAgendaTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AgendaCell {
                    cell.becomeFirstResponderToTextField()
                }
                
            }.disposed(by: disposeBag)
    }
}

private extension HomeViewController {
    func updateViewInsetForKeyboardState(_ isShowKeyboard: Bool, _ keyboardHeight: CGFloat) {
        print("updateViewInsetForKeyboardHeight")
        let isVisibleCalendar = self.homeView.calendarVisibleButton.isVisibleCalendar
        var newInset = UIEdgeInsets()
        
        if isVisibleCalendar {
            // 캘린더가 보여지고 있을 때, 키보드가 나타나면 (캘린더 높이 + 키보드 높이) 키보드가 사라지면 (캘린더 높이)
            let newBottomInset = isShowKeyboard ? homeView.calendarViewHeight + keyboardHeight : homeView.calendarViewHeight
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(newBottomInset), right: 0)
        } else {
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.homeView.scrollView.contentInset = newInset
            self.homeView.scrollView.scrollIndicatorInsets = newInset
        }
    }
    
    func updateCalendarVisibility(_ isVisible: Bool) {
        let newCalendarHeight: CGFloat = isVisible ? self.homeView.calendarViewHeight : 0
        let newContentInset: UIEdgeInsets = isVisible ? UIEdgeInsets(top: 0, left: 0, bottom: homeView.calendarViewHeight, right: 0) : .zero
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.homeView.calendarView.snp.updateConstraints {
                $0.height.equalTo(newCalendarHeight)
            }
            
            self.homeView.scrollView.contentInset = newContentInset
            self.homeView.scrollView.scrollIndicatorInsets = newContentInset
            
            self.view.layoutIfNeeded()
        }
    }
    
}
