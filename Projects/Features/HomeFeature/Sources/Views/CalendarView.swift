import UIKit
import Utility
import DesignSystem
import SnapKit
import Then

public final class CalendarView: UIView {
    
    let emptyView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubViews() {
        self.addSubview(emptyView)
    }
    
    func setLayout() {
        emptyView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
    
}
