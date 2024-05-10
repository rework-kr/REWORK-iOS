import UIKit
import DesignSystem
import SnapKit
import Then

public final class AgendaCell: UITableViewCell {
    public static let reuseIdentifier = String(describing: AgendaCell.self)

    let completeButton = UIButton().then {
        $0.layer.cornerRadius = 9 // 원의 반지름을 버튼의 높이의 절반으로 설정
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.clipsToBounds = true
    }
    
    let agendaTitleLabel = UITextField().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        $0.textColor = UIColor(hex: "746A6A")
        //$0.numberOfLines = 0
        $0.attributedPlaceholder = NSAttributedString(
            string: "아젠다 추가하기",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                .foregroundColor: UIColor.lightGray
            ]
        )
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func configure(title: String) {
        agendaTitleLabel.text = title
    }
}

private extension AgendaCell {
    func addSubViews() {
        contentView.addSubview(completeButton)
        contentView.addSubview(agendaTitleLabel)
    }

    func setLayout() {
        completeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        agendaTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(completeButton.snp.right).offset(10)
            $0.right.equalToSuperview().inset(40)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.centerY.equalToSuperview()
            
            
        }
    }
}
