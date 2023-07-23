import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "TrackerCollectionViewHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 19, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: CategoryModel) {
        titleLabel.text = model.title
    }
    
    private func makeViewLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
}
