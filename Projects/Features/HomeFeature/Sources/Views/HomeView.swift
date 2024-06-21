import UIKit
import SnapKit
import Then
import DesignSystem
import Utility

final class HomeView: UIView {
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
        //$0.separatorStyle = .none
    }
    
    weak var agendaCellDelegate: AgendaCellDelegate?
    
    lazy var todayAgendaTableViewDiffableDataSource = AgendaDataSource.create(tableView: todayAgendaTableView, agendaCellDelegate: agendaCellDelegate, agendaType: .uncompleted)
    
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
    
    lazy var completedAgendaTableViewDiffableDataSource = AgendaDataSource.create(tableView: completedAgendaTableView, agendaCellDelegate: agendaCellDelegate, agendaType: .completed)
    
    public let calendarViewHeight: CGFloat = 260
    
    public init() {
        super.init(frame: .zero)
        addViews()
        setLayout()
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
        
        let contentViewHeight: CGFloat = APP_HEIGHT() - STATUS_BAR_HEIGHT()
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(STATUS_BAR_HEIGHT())
            $0.height.equalTo(contentViewHeight)
            $0.bottom.equalToSuperview()
                //.offset(-SAFEAREA_BOTTOM_HEIGHT())
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
            //$0.horizontalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(280)
            $0.height.equalTo(0)
            $0.centerX.equalToSuperview()
        }
        
        todayAgendaTitleBar.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(34)
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

