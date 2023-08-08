//
//  ContextMenuSection.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 09.05.2023.
//

import UIKit

public struct ContextMenuSection {
    let actions: [ContextMenuAction]
    let footer: Footer?
    
    public init(actions: [ContextMenuAction],
                footer: Footer? = nil) {
        self.actions = actions
        self.footer = footer
    }
    
    public struct Footer {
        let height: CGFloat?
        let color: UIColor?
        
        public init(height: CGFloat? = nil,
                    color: UIColor? = nil) {
            self.height = height
            self.color = color
        }
    }
}
