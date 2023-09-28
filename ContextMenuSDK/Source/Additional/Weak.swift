//
//  Weak.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 29.09.2023.
//

import Foundation

class Weak<T: AnyObject>: Equatable, Hashable {
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.object === rhs.object
    }
}
