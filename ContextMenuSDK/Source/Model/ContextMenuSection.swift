//
//  ContextMenuSection.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 09.05.2023.
//

import UIKit

public struct ContextMenuSection {
    let actions: [ContextMenuAction]
    let header: Header?
    
    public init(actions: [ContextMenuAction],
                header: Header? = nil) {
        self.actions = actions
        self.header = header
    }
    
    public struct Header {
        let height: CGFloat?
        let color: UIColor?
        
        public init(height: CGFloat? = nil,
                    color: UIColor? = nil) {
            self.height = height
            self.color = color
        }
    }
}
