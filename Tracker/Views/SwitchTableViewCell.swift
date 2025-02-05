import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func didChangeState(isOn: Bool, for weekDay: WeekDay)
}

final class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switcher = UISwitch()
        
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        
        return switcher
    }()
    
    private var weekDay: WeekDay?
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(options: SwitchOptions) {
        weekDay = options.weekDay
        nameLabel.text = options.name
        switchControl.isOn = options.isOn
    }
    
    @objc private func didToggleSwitch() {
        guard let weekDay = weekDay else {
            return
        }
        delegate?.didChangeState(isOn: switchControl.isOn, for: weekDay)
    }
    
    private func makeViewLayout() {
        contentView.backgroundColor = .ypBackgroundDay
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchControl)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
