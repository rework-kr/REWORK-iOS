import UIKit
import SnapKit
import Then
import DesignSystem
import Utility

final class NewHomeView: UIView {
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
    
    let calendarView = UICalendarView().then {
        $0.wantsDateDecorations = true
        $0.locale = Locale(identifier: "ko_KR")
        $0.fontDesign = .rounded
    }
    
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
        $0.isEditing = true
        //$0.separatorStyle = .none
    }
    
    weak var agendaCellDelegate: AgendaCellDelegate?
    
    lazy var todayAgendaTableViewDiffableDataSource = AgendaDataSource(tableView: todayAgendaTableView)
    {
        [weak self] tableView, indexPath, itemIdentifier in
        guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title, type: .uncompleted)
        cell.delegate = self.agendaCellDelegate
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
    
    lazy var completedAgendaTableViewDiffableDataSource = AgendaDataSource(tableView: completedAgendaTableView)
    { 
        [weak self] tableView, indexPath, itemIdentifier in
        guard let self, let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reuseIdentifier, for: indexPath) as? AgendaCell
        else { return UITableViewCell() }
        cell.configure(title: itemIdentifier.title, type: .completed)
        cell.delegate = self.agendaCellDelegate
        cell.selectionStyle = .none
        return cell
    }
    
    private let testLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "HelloNewHomeView"
    }
    
    public let calendarViewHeight: CGFloat = 260
    
    public init() {
        super.init(frame: .zero)
        addViews()
        setLayout()
        initDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(scrollView)
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
        self.backgroundColor = .white
        //contentView.backgroundColor = .lightGray
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.height.equalTo(scrollView.frameLayoutGuide)
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
            //$0.horizontalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(280)
            $0.height.equalTo(0)
            $0.centerX.equalToSuperview()
        }
        
        todayAgendaTitleBar.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        todayAgendaTableView.snp.makeConstraints {
            $0.top.equalTo(todayAgendaTitleBar.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        
        completedAgendaCount.snp.makeConstraints {
            $0.top.equalTo(todayAgendaTableView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completedAgendaTableView.snp.makeConstraints {
            $0.top.equalTo(completedAgendaCount.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(220)
        }
        
    }
    
}

extension NewHomeView {
    func initDiffableDataSource() {
        var snapshot1 = todayAgendaTableViewDiffableDataSource.snapshot()
        var snapshot2 = completedAgendaTableViewDiffableDataSource.snapshot()
        
        snapshot1.appendSections([0])
        snapshot2.appendSections([0])
        snapshot1.appendItems([], toSection: 0)
        snapshot2.appendItems([], toSection: 0)
        
        todayAgendaTableViewDiffableDataSource.apply(snapshot1, animatingDifferences: true)
        completedAgendaTableViewDiffableDataSource.apply(snapshot2, animatingDifferences: true)
    }
}
