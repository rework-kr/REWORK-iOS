import UIKit
import DesignSystem
import BaseFeature
import SnapKit
import Then
import Utility

public class DemoSignInViewController: UIViewController {
    private let label = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = "DemoIntroVC"
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        view.backgroundColor = .green
        self.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
