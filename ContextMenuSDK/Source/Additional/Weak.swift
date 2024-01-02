//
//  Weak.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 29.09.2023.
//

import Foundation

class Weak<T: AnyObject>: Hashable where T: Hashable {
    weak private(set) var object: T?
    private(set) var hashValue: Int
    
    init(_ object: T) {
        self.object = object
        self.hashValue = object.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
    
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.object === rhs.object
    }
}
