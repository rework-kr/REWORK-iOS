import UIKit
import Utility
import DesignSystem
import SnapKit
import Then

public final class ImageTextButton: UIView {
    public var button = UIButton()
    
    let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
        $0.distribution = .equalCentering
    }
    
    let imageView = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
        $0.textColor = .black
    }
    
    let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 10)
        $0.textColor = .gray
    }
    
    private var isVisibleCalendar: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubViews() {
        self.addSubview(hStackView)
        hStackView.addArrangedSubview(imageView)
        hStackView.addArrangedSubview(vStackView)
        vStackView.addArrangedSubview(subTitleLabel)
        vStackView.addArrangedSubview(titleLabel)
        self.addSubview(button)
    }
    
    func setLayout() {
        self.backgroundColor = .white
        hStackView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        button.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
    }
    
    public func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func setSubTitle(_ subTitle: String) {
        subTitleLabel.text = subTitle
    }
}
