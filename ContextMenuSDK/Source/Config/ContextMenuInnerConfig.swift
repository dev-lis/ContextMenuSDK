//
//  ContextMenuInnerConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

struct ContextMenuInnerConfig {
    let actionSections: [ContextMenuSection]
    let trigger: Trigger
    let position: MenuPosition
    let withBlur: Bool
    let menuWidth: CGFloat?
    let shouldMoveContentIfNeed: Bool
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                withBlur: Bool,
                menuWidth: CGFloat?,
                shouldMoveContentIfNeed: Bool) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.withBlur = withBlur
        self.menuWidth = menuWidth
        self.shouldMoveContentIfNeed = shouldMoveContentIfNeed
    }
}
