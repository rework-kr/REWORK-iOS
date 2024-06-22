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

public final class NewHomeViewController: BaseReactorViewController<HomeReactor> {    
    let homeView = NewHomeView()
    
    public override func loadView() {
        view = homeView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setDelegate()
        hideKeyboardWhenTappedAround()
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
        let sharedState = reactor.state.share()
        
        reactor.pulse(\.$isVisibleCalendar)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, isVisibleCalendar in
                print("isVisibleCalendar", isVisibleCalendar)
                owner.homeView.calendarVisibleButton.toggleCalendarVisible()
                owner.updateCalendarVisibility(isVisibleCalendar)
            }).disposed(by: disposeBag)
        
        sharedState.map(\.uncompletedAgendaDataSource)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, dataSource in
                print("uncompletedAgendaDataSource changed!!!!")
                var snapshot = owner.homeView.todayAgendaTableViewDiffableDataSource.snapshot()
                snapshot.appendItems(dataSource, toSection: 0)
                owner.homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        sharedState.map(\.completedAgendaDataSource)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, dataSource in
                print("CompletedAgendaDataSource changed!!!!")
                var snapshot = owner.homeView.completedAgendaTableViewDiffableDataSource.snapshot()
                snapshot.appendItems(dataSource, toSection: 0)
                owner.homeView.completedAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
            }).disposed(by: disposeBag)
        
        sharedState.map(\.keyboardState)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, state in
                owner.updateViewInsetForKeyboardState(state.isShow, state.height)
                owner.homeView.todayAgendaTableView.setEditing(!state.isShow, animated: false)
            }).disposed(by: disposeBag)
        
    }
    
    public override func bindAction(reactor: HomeReactor) {
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
        
        homeView.calendarVisibleButton.button.rx.tap
            .map { _ in Reactor.Action.calendarVisibleButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeView.addButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
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
                
            }).disposed(by: disposeBag)
    }
    
}

private extension NewHomeViewController {
    func updateViewInsetForKeyboardState(_ isShowKeyboard: Bool, _ keyboardHeight: CGFloat) {
        print("updateViewInsetForKeyboardHeight 호출", isShowKeyboard, keyboardHeight)
        let isVisibleCalendar = self.homeView.calendarVisibleButton.isVisibleCalendar
        var newInset = UIEdgeInsets()
        
        if isVisibleCalendar {
            // 캘린더가 보여지고 있을 때, 키보드가 나타나면 (캘린더 높이 + 키보드 높이) 키보드가 사라지면 (캘린더 높이)
            let newBottomInset = isShowKeyboard ? homeView.calendarViewHeight + keyboardHeight : homeView.calendarViewHeight
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: newBottomInset, right: 0)
        } else {
            newInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }

        self.homeView.scrollView.contentInset = newInset
        //self.homeView.scrollView.scrollIndicatorInsets = newInset
        //self.view.layoutIfNeeded()
    }
    
    func updateCalendarVisibility(_ isVisible: Bool) {
        print("updateCalendarVisibility 호출", isVisible)
        let newCalendarHeight: CGFloat = isVisible ? self.homeView.calendarViewHeight : 0
        let newContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: newCalendarHeight, right: 0)
        
        self.homeView.calendarView.snp.updateConstraints {
            $0.height.equalTo(newCalendarHeight)
        }
        self.homeView.scrollView.contentInset = newContentInset
        //self.homeView.scrollView.scrollIndicatorInsets = newContentInset
        //self.view.layoutIfNeeded()
    }
    
}
