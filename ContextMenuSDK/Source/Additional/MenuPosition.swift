//
//  MenuPosition.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 08.05.2023.
//

import Foundation

public enum MenuPosition {
    case topLeft
    case topCenter
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    var top: Bool {
        guard self == .topLeft || self == .topCenter || self == .topRight else {
            return false
        }
        return true
    }
    
    var bottom: Bool {
        guard self == .bottomLeft || self == .bottomCenter || self == .bottomRight else {
            return false
        }
        return true
    }
}
