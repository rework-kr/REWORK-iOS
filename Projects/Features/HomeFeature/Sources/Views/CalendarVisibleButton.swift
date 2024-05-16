import UIKit
import Utility
import DesignSystem
import SnapKit
import Then

public final class CalendarVisibleButton: UIView {
    
    public var button = UIButton()
    
    let calendarImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Home.calendar.image
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.text = "다른 일정의 아젠다를 확인하고 싶으신가요?"
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 11)
    }
    
    var arrowImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Home.arrowDown.image
    }
    
    let barView = UIView().then {
        $0.backgroundColor = UIColor(hex: "343434")
        $0.layer.cornerRadius = 8
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        
    }
    
    //public private(set) var isVisibleCalendar: Bool = false
    public var isVisibleCalendar: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        self.addSubview(barView)
        barView.addSubview(calendarImageView)
        barView.addSubview(titleLabel)
        barView.addSubview(arrowImageView)
        self.addSubview(button)
    }
    
    func setLayout() {
        barView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        calendarImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(calendarImageView.snp.right).offset(10)
            $0.right.equalTo(arrowImageView.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
    }
    
    public func toggleCalendarVisible() {
        isVisibleCalendar.toggle()
        
        UIView.animate(withDuration: 0.3) {
            let angle: CGFloat = self.isVisibleCalendar ? .pi : 0
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
            
            self.layoutIfNeeded()
        }
    }
}
