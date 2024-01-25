//
//  TabBarCoordinator.swift
//
//
//  Created by Chung Han Hsin on 2024/1/25.
//

import UIKit

public class TabBarCoordinator: Coordinator {
    public var onCanceled: ((Coordinator) -> Void)?
    public var onFinished: ((Coordinator) -> Void)?
    public var onFailed: ((Coordinator, Error) -> Void)?
    public var childCoordinators: [Coordinator] = []
    public lazy var router = makeAppRouter()
    
    let tabBarController: UITabBarController
    let tabCoordinators: [Coordinator]
    init(tabBarController: UITabBarController, tabCoordinators: [Coordinator]) {
        self.tabBarController = tabBarController
        self.tabCoordinators = tabCoordinators
    }
    
    public func start(animated: Bool) {
        tabCoordinators.forEach {
            $0.addAndStart(parent: self)
            tabBarController.viewControllers?.append($0.navigationController)
        }
    }
}
