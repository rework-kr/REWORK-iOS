import UIKit
import DesignSystem
import SnapKit
import Then

public enum AgendaType {
    case uncompleted, completed
}

public protocol AgendaCellDelegate: AnyObject {
    func textFieldEditingDidEnd(_ cell: AgendaCell, _ text: String?)
    func uncheckButtonDidTap(_ cell: AgendaCell, _ text: String?)
    func checkButtonDidTap(_ cell: AgendaCell, _ text: String?)
}

public final class AgendaCell: UITableViewCell {
    public static let reuseIdentifier = String(describing: AgendaCell.self)
    
    let uncheckButton = UIButton().then {
        $0.layer.cornerRadius = 9 // 원의 반지름을 버튼의 높이의 절반으로 설정
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.clipsToBounds = true
    }
    
    let checkButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Home.checkFill.image, for: .normal)
    }
    
    let agendaTitleTextField = UITextField().then {
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
    public weak var delegate: AgendaCellDelegate?
    public private(set) var type: AgendaType = .uncompleted
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        agendaTitleTextField.delegate = self
        uncheckButton.addTarget(self, action: #selector(didTapUnCheckButton(_:)), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(didTapCheckButton(_:)), for: .touchUpInside)
        addSubViews()
        setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func configure(title: String, type: AgendaType) {
        agendaTitleTextField.text = title
        updateButtonHidden(type)
    }
    
    public func becomeFirstResponderToTextField() {
        agendaTitleTextField.becomeFirstResponder()
    }
    
}

private extension AgendaCell {
    func addSubViews() {
        contentView.addSubview(uncheckButton)
        contentView.addSubview(checkButton)
        contentView.addSubview(agendaTitleTextField)
    }

    func setLayout() {
        uncheckButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        checkButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        agendaTitleTextField.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(uncheckButton.snp.right).offset(10)
            $0.right.equalToSuperview().inset(40)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.centerY.equalToSuperview()
        }
        
    }
}

private extension AgendaCell {
    func updateButtonHidden(_ type: AgendaType) {
        self.type = type
        let currentType = self.type
        switch currentType {
        case .uncompleted:
            checkButton.isHidden = true
            uncheckButton.isHidden = false
        case .completed:
            checkButton.isHidden = false
            uncheckButton.isHidden = true
        }
        
    }
}

extension AgendaCell: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEditingDidEnd(self, textField.text)
    }
}

extension AgendaCell {
    @objc func didTapUnCheckButton(_ sender: UIButton) {
        delegate?.uncheckButtonDidTap(self, agendaTitleTextField.text)
    }
    @objc func didTapCheckButton(_ sender: UIButton) {
        print("⭐️1. didTapCheckButton-", agendaTitleTextField.text ?? "nil")
        delegate?.checkButtonDidTap(self, agendaTitleTextField.text)
    }
}
