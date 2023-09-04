import UIKit

final class CreateEventViewController: UIViewController {
    
    private let nameField: CustomTextField = {
        let field = CustomTextField()
        
        field.placeholder = "Введите название трекера"
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = .ypBackgroundDay
        
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 16
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        return field
    }()
    
    private let settingTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        return table
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Emoji"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private var settings: Array<SettingOptions> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTable.dataSource = self
        settingTable.delegate = self
        
        appendSettingsToList()
        setupNavigationBar()
        makeViewLayout()
        hideKeyboardWhenDidTap()
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreateButton() {}
    
    private func appendSettingsToList() {
        settings.append(
            SettingOptions(
                name: "Категория",
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.configureCategory()
                }
            )
        )
    }
    
    private func configureCategory() {}
    
    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = "Новое нерегулярное событие"
    }
    
    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay
        
        let buttonStack = makeButtonStack()
        
        view.addSubview(nameField)
        view.addSubview(settingTable)
        view.addSubview(buttonStack)
        view.addSubview(emojiTitle)
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        emojiTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            settingTable.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            settingTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emojiTitle.topAnchor.constraint(equalTo: settingTable.bottomAnchor, constant: 32),
            emojiTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28 ),
            emojiTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 295)
        ])
    }
    
    private func makeButtonStack() -> UIStackView {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(createButton)
        
        return stack
    }
}

extension CreateEventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView
            .dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell
        else {
            preconditionFailure("Failed to cast UITableViewCell as SettingTableViewCell")
        }
        settingCell.configure(options: settings[indexPath.row])
        
        if indexPath.row == settings.count - 1 { // hide separator for last cell
            let centerX = settingCell.bounds.width / 2
            settingCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
        return settingCell
    }
}

extension CreateEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}
