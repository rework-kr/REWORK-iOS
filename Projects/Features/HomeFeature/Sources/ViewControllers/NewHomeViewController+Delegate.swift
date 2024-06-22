import UIKit
import DesignSystem
import Utility

extension NewHomeViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }
        reactor?.action.onNext(.dateDidSelect(date))
    }
}

extension NewHomeViewController: UITableViewDelegate {
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

extension NewHomeViewController: AgendaCellDelegate {
    public func uncheckButtonDidTap(_ cell: AgendaCell, _ text: String?) {
        HapticManager.shared.impact(style: .medium)
        deleteCellInTodayAgenda(cell)
        appendCellInCompleteAgenda(text ?? "")
        let unCompletedAgendaDataSource = homeView.todayAgendaTableViewDiffableDataSource.snapshot().itemIdentifiers
        let completedAgendaDataSource = homeView.completedAgendaTableViewDiffableDataSource.snapshot().itemIdentifiers
        reactor?.action.onNext(.unCheckButtonDidTap(
            unCompletedAgendaDataSource: unCompletedAgendaDataSource,
            completedAgendaDataSource: completedAgendaDataSource))
    }
    
    public func checkButtonDidTap(_ cell: AgendaCell, _ text: String?) {
        print("⭐️2. checkButtonDidTap-")
        
        HapticManager.shared.impact(style: .medium)
        deleteCellInCompletedAgenda(cell)
        appendCellInTodayAgenda(text ?? "")
        let unCompletedAgendaDataSource = homeView.todayAgendaTableViewDiffableDataSource.snapshot().itemIdentifiers
        let completedAgendaDataSource = homeView.completedAgendaTableViewDiffableDataSource.snapshot().itemIdentifiers
        reactor?.action.onNext(.checkButtonDidTap(
            unCompletedAgendaDataSource: unCompletedAgendaDataSource,
            completedAgendaDataSource: completedAgendaDataSource))
    }
    
    public func textFieldEditingDidEnd(_ cell: AgendaCell, _ text: String?) {
        print("textFieldEditingDidEnd", text)
        guard let text = text else { return }
        if text.isEmpty {
            deleteCellInTodayAgenda(cell)
        } else {
            updateCellInTodayAgenda(cell, text)
        }
        let dataSource = homeView.todayAgendaTableViewDiffableDataSource.snapshot().itemIdentifiers
        reactor?.action.onNext(.textFieldEditingDidEnd(dataSource))
    }
    
    private func appendCellInTodayAgenda(_ text: String) {
        print("🚀 appendCellInTodayAgenda")
        var snapshot = homeView.todayAgendaTableViewDiffableDataSource.snapshot()
        
        if let first = snapshot.itemIdentifiers.first {
            snapshot.insertItems([AgendaSectionItem(title: text)], beforeItem: first)
        } else {
            snapshot.appendItems([AgendaSectionItem(title: text)])
        }
        
        homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func deleteCellInTodayAgenda(_ cell: AgendaCell) {
        print("🚀 deleteCellInTodayAgenda")
        var snapshot = homeView.todayAgendaTableViewDiffableDataSource.snapshot()
        
        // TODO: 스크롤 되어 셀이 안보이면 못찾음
        guard let row = homeView.todayAgendaTableView.indexPath(for: cell)?.row else { return }
        guard let item = snapshot.itemIdentifiers[safe: row] else { return }
        
        snapshot.deleteItems([item])
        homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateCellInTodayAgenda(_ cell: AgendaCell, _ text: String) {
        print("🚀 updateCellInTodayAgenda")
        var snapshot = homeView.todayAgendaTableViewDiffableDataSource.snapshot()
        
        guard let indexPath = homeView.todayAgendaTableView.indexPath(for: cell) else { return }
        guard let oldItem = homeView.todayAgendaTableViewDiffableDataSource.itemIdentifier(for: indexPath) else { return }
        
        let newItem = AgendaSectionItem(title: text)
        snapshot.insertItems([newItem], beforeItem: oldItem)
        snapshot.deleteItems([oldItem])
        
        homeView.todayAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    private func appendCellInCompleteAgenda(_ text: String) {
        print("🚀 appendCellInCompleteAgenda")
        var snapshot = homeView.completedAgendaTableViewDiffableDataSource.snapshot()
        
        if let first = snapshot.itemIdentifiers.first {
            snapshot.insertItems([AgendaSectionItem(title: text)], beforeItem: first)
        } else {
            snapshot.appendItems([AgendaSectionItem(title: text)])
        }
        
        homeView.completedAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func deleteCellInCompletedAgenda(_ cell: AgendaCell) {
        print("🚀 deleteCellInCompletedAgenda")
        var snapshot = homeView.completedAgendaTableViewDiffableDataSource.snapshot()
        
        guard let row = homeView.completedAgendaTableView.indexPath(for: cell)?.row else { return }
        guard let item = snapshot.itemIdentifiers[safe: row] else { return }
        
        snapshot.deleteItems([item])
        homeView.completedAgendaTableViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
