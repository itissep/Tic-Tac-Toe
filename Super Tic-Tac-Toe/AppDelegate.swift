//
//  AppDelegate.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 04.05.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: BaseCoordinatorDescription?
    var serviceAssembly: ServiceAssemblyDescription = ServiceAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let navController = UINavigationController()
        coordinator = BaseCoordinator(navigationController: navController,
                                      gamesListAssembly: GamesListAssembly(),
                                      gameAssembly: GameAssembly(serviceAssembly: serviceAssembly))
        coordinator?.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

