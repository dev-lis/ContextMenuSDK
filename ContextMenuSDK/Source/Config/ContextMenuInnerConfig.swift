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
    let shouldMoveContentIfNeed: Bool
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                withBlur: Bool,
                shouldMoveContentIfNeed: Bool) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.withBlur = withBlur
        self.shouldMoveContentIfNeed = shouldMoveContentIfNeed
    }
}
