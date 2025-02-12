import UIKit

protocol CreateEventViewControllerDelegate: AnyObject {
    func didCreateNewEvent(model: TrackerModel)
    func didCancelNewHabit()
}

final class CreateEventViewController: UIViewController {
    
    weak var delegate: CreateEventViewControllerDelegate?
    let colorCollectionDelegate = ColorCollectionViewDelegate()
    let emojiCollectionDelegate = EmojiCollectionViewDelegate()
    
    private let emojiCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier
        )

        return collection
    }()
    
    
    private let colorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )

        return collection
    }()
    
    private let testEmojis: Array<String> = [
        "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏",
        "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆",
        "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅",
    ]
    
    private lazy var emojiTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Emoji"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var colorTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Цвет"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var nameField: CustomTextField = {
        let field = CustomTextField()
        
        field.placeholder = "Введите название трекера"
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = .ypBackgroundDay
        
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 16
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        field.addTarget(self, action: #selector(setCreateButtonState), for: .editingChanged)
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
    
    private func configureCollections() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5 // значение отступа между ячейками по горизонтали
        layout.minimumLineSpacing = 0 //  значение отступа между ячейками по вертикали

        emojiCollection.collectionViewLayout = layout
        colorCollection.collectionViewLayout = layout
    }
    
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
        button.isEnabled = false
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private var settings: Array<SettingOptions> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTable.dataSource = self
        settingTable.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.delegate = emojiCollectionDelegate
        colorCollection.dataSource = self
        colorCollection.delegate = colorCollectionDelegate
        configureCollections()
        
        appendSettingsToList()
        setupNavigationBar()
        makeViewLayout()
        hideKeyboardWhenDidTap()
    }
    
    @objc private func setCreateButtonState() {
        guard let habitName = nameField.text else {
            return
        }
        if habitName.isEmpty {
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        } else {
            createButton.backgroundColor = .ypBlackDay
            createButton.isEnabled = true
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreateButton() {
        guard let eventName = nameField.text else {
            return
        }
        
        let event = TrackerModel(
            id: UUID(),
            name: eventName.trimmingCharacters(in: .whitespaces),
            color: colorCollectionDelegate.selectedColorNum + 1,
            emoji: testEmojis[emojiCollectionDelegate.selectedEmojiNum],
            schedule: Set<WeekDay>(),
            creationDate: Date() // Используем текущую дату для определения дня недели
        )
        delegate?.didCreateNewEvent(model: event)
    }
    
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
        view.addSubview(emojiCollection)
        view.addSubview(colorTitle)
        view.addSubview(colorCollection)
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        emojiTitle.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        colorTitle.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        
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
            emojiTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 295),
            
            emojiCollection.topAnchor.constraint(equalTo: emojiTitle.bottomAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            emojiCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            emojiCollection.heightAnchor.constraint(equalToConstant: 156),
            
            colorTitle.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16),
            colorTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -299),
            
            colorCollection.topAnchor.constraint(equalTo: colorTitle.bottomAnchor),
            colorCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            colorCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            colorCollection.heightAnchor.constraint(equalToConstant: 156),
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

extension CreateEventViewController: UICollectionViewDelegate {
    
}

extension CreateEventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollection {
            guard let emojiCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as EmojiCollectionViewCell")
            }
            
            emojiCell.configure(emoji: testEmojis[indexPath.row], at: indexPath)
            
            return emojiCell
        }
        else if collectionView == colorCollection {
            guard let colorCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as EmojiCollectionViewCell")
            }
            
            colorCell.configure(at: indexPath)
            
            return colorCell
        }
        else {
            return UICollectionViewCell()
        }
    }
}

