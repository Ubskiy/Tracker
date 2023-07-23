import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.ypGray.cgColor
        
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        let trackersController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsController = UINavigationController(rootViewController: StatisticsViewController())
        
        trackersController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersTab"),
            tag: 0
        )
        statisticsController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticsTab"),
            tag: 1
        )
        viewControllers = [trackersController, statisticsController]
    }
}

