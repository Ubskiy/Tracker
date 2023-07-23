import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateNewTracker(model: TrackerModel)
}

final class CreateTrackerViewController: UIViewController {
    
    private lazy var createHabitButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createEventButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        makeViewLayout()
    }
    
    @objc private func didTapHabitButton() {
        let createHabitController = CreateHabitViewController()
        createHabitController.delegate = self
        present(UINavigationController(rootViewController: createHabitController), animated: true)
    }
    
    @objc private func didTapEventButton() {
        let createEventController = CreateEventViewController()
        present(UINavigationController(rootViewController: createEventController), animated: true)
    }
    
    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = "Создание трекера"
    }
    
    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay
        
        let buttonStack = makeButtonStack()
        
        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func makeButtonStack() -> UIStackView {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 16
        
        stack.addArrangedSubview(createHabitButton)
        stack.addArrangedSubview(createEventButton)
        
        return stack
    }
}

extension CreateTrackerViewController: CreateHabitViewControllerDelegate {
    
    func didCreateNewHabit(model: TrackerModel) {
        delegate?.didCreateNewTracker(model: model)
    }
    
    func didCancelNewHabit() {
        dismiss(animated: true)
    }
}
