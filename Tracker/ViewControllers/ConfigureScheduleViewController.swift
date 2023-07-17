import UIKit

protocol ConfigureScheduleViewControllerDelegate: AnyObject {
    func didConfigure(schedule: Set<WeekDay>)
}

final class ConfigureScheduleViewController: UIViewController {
    
    private let switchTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 525).isActive = true
        
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.isEnabled = false
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    private var schedule: Set<WeekDay> = []
    private var switches: Array<SwitchOptions> = []
    
    weak var delegate: ConfigureScheduleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchTable.dataSource = self
        switchTable.delegate = self
        
        appendSwitches()
        setupNavigationBar()
        makeViewLayout()
    }
    
    @objc private func didTapDoneButton() {
        delegate?.didConfigure(schedule: schedule)
    }
    
    private func appendSwitches() {
        switches.append(contentsOf: [
            SwitchOptions(weekDay: .monday, name: "Понедельник", isOn: schedule.contains(.monday)),
            SwitchOptions(weekDay: .tuesday, name: "Вторник", isOn: schedule.contains(.tuesday)),
            SwitchOptions(weekDay: .wednesday, name: "Среда", isOn: schedule.contains(.wednesday)),
            SwitchOptions(weekDay: .thursday, name: "Четверг", isOn: schedule.contains(.thursday)),
            SwitchOptions(weekDay: .friday, name: "Пятница", isOn: schedule.contains(.friday)),
            SwitchOptions(weekDay: .saturday, name: "Суббота", isOn: schedule.contains(.saturday)),
            SwitchOptions(weekDay: .sunday, name: "Воскресенье", isOn: schedule.contains(.sunday))
        ])
    }
    
    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = "Расписание"
    }
    
    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(switchTable)
        view.addSubview(doneButton)
        
        switchTable.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            switchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            switchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setDoneButtonState() {
        if schedule.isEmpty {
            doneButton.backgroundColor = .ypGray
            doneButton.isEnabled = false
        } else {
            doneButton.backgroundColor = .ypBlackDay
            doneButton.isEnabled = true
        }
    }
}

extension ConfigureScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let switchCell = tableView
            .dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell
        else {
            preconditionFailure("Failed to cast UITableViewCell as SwitchTableViewCell")
        }
        switchCell.delegate = self
        switchCell.configure(options: switches[indexPath.row])
        
        if indexPath.row == switches.count - 1 { // hide separator for last cell
            let centerX = switchCell.bounds.width / 2
            switchCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
        return switchCell
    }
}

extension ConfigureScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConfigureScheduleViewController: SwitchTableViewCellDelegate {
    
    func didChangeState(isOn: Bool, for weekDay: WeekDay) {
        if isOn {
            schedule.insert(weekDay)
        } else {
            schedule.remove(weekDay)
        }
        setDoneButtonState()
    }
}
