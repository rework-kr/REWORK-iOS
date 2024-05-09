import UIKit
import Utility
import DesignSystem
import Then

class CalendarBarView: UIView {
    
    let imageView = UIImageView().then {
        $0.image = DesignSystemAsset.SignIn.rework.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        
    }
    
    func setLayout() {
    }
}
