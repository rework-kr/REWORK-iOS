import UIKit

class AgendaDataSource: UITableViewDiffableDataSource<Int, AgendaSectionItem> {
    
    public static func create(tableView: UITableView, agendaCellDelegate: AgendaCellDelegate?, agendaType: AgendaType) -> UITableViewDiffableDataSource<Int, AgendaSectionItem> {
        let dataSource = UITableViewDiffableDataSource<Int, AgendaSectionItem>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            return configureCell(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier, delegate: agendaCellDelegate, agendaType: agendaType)
        }
        return dataSource
    }
    
    private static func configureCell(tableView: UITableView, indexPath: IndexPath, itemIdentifier: AgendaSectionItem, delegate: AgendaCellDelegate?, agendaType: AgendaType) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title, type: agendaType)
        cell.delegate = delegate
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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

//AgendaDataSource(
//    tableView: completedAgendaTableView
//) { [weak self] tableView, indexPath, itemIdentifier in
//    guard let self else { return UITableViewCell() }
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell
//    else { return UITableViewCell() }
//    cell.configure(title: itemIdentifier.title, type: .completed)
//    cell.delegate = agendaCellDelegate
//    cell.selectionStyle = .none
//    return cell
//}
