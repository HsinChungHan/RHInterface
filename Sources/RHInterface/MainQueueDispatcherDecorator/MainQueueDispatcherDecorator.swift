//
//  MainQueueDispatcherDecorator.swift
//
//
//  Created by Chung Han Hsin on 2024/1/26.
//

import Foundation

public final class MainQueueDispatcherDecorator<T> {
    public let decoratee: T
    public init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    public func dispatchToMainThread(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}
