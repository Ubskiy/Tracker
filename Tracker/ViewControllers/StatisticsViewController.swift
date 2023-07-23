import UIKit

final class StatisticsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Статистика"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 34, weight: .bold)
        
        return label
    }()
    
    private let placeholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "StatisticsPlaceholder"))
        
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        
        return image
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViewLayout()
    }
    
    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(titleLabel)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
}

