import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AuthDomain
import BaseFeature
import SignInFeature
import HomeFeature
import DesignSystem



public protocol TabItemDelegate: AnyObject {
    func tabItemDidTap(tabItemType: TabItemType)
}

class TabItemView: UIView {
    public var tabItemType: TabItemType
    
    private var imageView = UIImageView().then {
        $0.contentMode = .center
    }
    private var titleLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
        
    var isSelected: Bool = false {
        didSet {
            self.updateUI(isSelected: isSelected)
        }
    }
    
    public weak var delegate: TabItemDelegate?
    
    init(tabItemType: TabItemType) {
        self.tabItemType = tabItemType
        self.imageView.image = tabItemType.image
        self.titleLabel.text = tabItemType.title
        super.init(frame: .zero)
        addView()
        setLayout()
        setGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().offset(5)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        delegate?.tabItemDidTap(tabItemType: self.tabItemType)
    }
    
    func updateUI(isSelected: Bool) {
        self.titleLabel.textColor = isSelected ? .blue : .white
    }
}
