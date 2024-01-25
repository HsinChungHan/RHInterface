//
//  Coordinator.swift
//  
//
//  Created by Chung Han Hsin on 2024/1/25.
//

import UIKit

public protocol Coordinator: AnyObject {
    var router: Router { get set }
    var childCoordinators: [Coordinator] { get set }
    func start(animated: Bool)
    
    var onCanceled: ((Coordinator) -> Void)? { get set }
    var onFinished: ((Coordinator) -> Void)? { get set }
    var onFailed: ((Coordinator, Error) -> Void)? { get set }
}

public extension Coordinator {
    var navigationController: UINavigationController {
        return router.navigationController
    }
    
    var topViewController: UIViewController? {
        return router.navigationController.topViewController
    }
    
    func add(childCoordinator: Coordinator) {
        childCoordinator.addingActionOnFinished { [weak self] childCoordinator in
            self?.remove(childCoordinator: childCoordinator)
        }
        
        childCoordinator.addingActionOnCanceled { [weak self] childCoordinator in
            self?.remove(childCoordinator: childCoordinator)
        }
        
        childCoordinator.addingActionOnFailed { [weak self] childCoordinator, _ in
            self?.remove(childCoordinator: childCoordinator)
        }
        
        childCoordinators.append(childCoordinator)
    }
    
    @discardableResult
    func addingActionOnCanceled(_ newAction: @escaping (Coordinator) -> Void) -> Self {
        let oldAction = self.onCanceled
        self.onCanceled = { coordinator in
            oldAction?(coordinator)
            newAction(coordinator)
        }
        return self
    }
    
    @discardableResult
    func addingActionOnFinished(_ newAction: @escaping (Coordinator) -> Void) -> Self {
        let oldAction = self.onFinished
        self.onFinished = { coordinator in
            oldAction?(coordinator)
            newAction(coordinator)
        }
        return self
    }
    
    @discardableResult
    func addingActionOnFailed(_ newAction: @escaping (Coordinator, Error?) -> Void) -> Self {
        let oldAction = self.onFailed
        self.onFailed = { coordinator, error in
            oldAction?(coordinator, error)
            newAction(coordinator, error)
        }
        return self
    }
    
    func remove(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.forEach {
            remove(childCoordinator: $0)
        }
    }
    
    func addAndStart(parent: Coordinator, animated: Bool=true) {
        parent.add(childCoordinator: self)
        start(animated: animated)
    }
    
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = .white
        return navigationController
    }
    
    func makeAppRouter() -> Router {
        let navigationController = makeNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return AppRouter(navigationController: navigationController)
    }
}
