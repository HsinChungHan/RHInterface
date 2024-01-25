//
//  AppRouter.swift
//
//
//  Created by Chung Han Hsin on 2024/1/25.
//

import UIKit

public class AppRouter: Router {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
