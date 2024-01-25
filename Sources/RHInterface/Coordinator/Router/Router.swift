//
//  Router.swift
//
//
//  Created by Chung Han Hsin on 2024/1/25.
//
import UIKit

public enum TransitionAction {
    case push
    case present
}

public protocol Router {
    var navigationController: UINavigationController { get set }
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool, completion: (() -> Void)?)
}

public extension Router {
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?=nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func pop(animated: Bool, completion: (() -> Void)?=nil) {
        navigationController.popViewController(animated: animated)
    }
}
