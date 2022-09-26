//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 30.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBatController()
        window?.makeKeyAndVisible()
    }
    
    private enum TabItemTepy: String {
        case habits 
        case info
        
        var title: String{
            switch self {
            case.habits:
                return "Сегодня"
            case.info:
                return "Информация"
            }
        }
        
        var tabBarItem: UITabBarItem{
            switch self {
            case .habits:
return UITabBarItem(title: "Привычки", image: UIImage(named: "habitstab"), tag: 0)
            case .info:
return UITabBarItem(title: "Информация", image: UIImage(named: "infotab"), tag: 1)
                
            }
        }
    }
    
    private func createNavigationController(for tabItemType: TabItemTepy)->
    UINavigationController {
        let viewController: UIViewController
        switch tabItemType {
        case .habits:
            viewController = HabitsViewController()
        case.info:
            viewController = InfoViewController()
        }
        viewController.title = tabItemType.title
        viewController.tabBarItem = tabItemType.tabBarItem
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createTabBatController()-> UITabBarController {
        let tabBarController = UITabBarController()
        UITabBar.appearance().backgroundColor = .systemGray6
        tabBarController.viewControllers = [
            self.createNavigationController(for: .habits),
            self.createNavigationController(for: .info)
        ]
        return tabBarController
    }
    
  }

