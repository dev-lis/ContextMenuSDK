//
//  ContextMenuConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuConfig {
    let actionSections: [ContextMenuSection]
    let position: MenuPosition
    let withBlur: Bool
    let shouldMoveContentIfNeed: Bool
    
    public init(actionSections: [ContextMenuSection],
                position: MenuPosition,
                withBlur: Bool = true,
                shouldMoveContentIfNeed: Bool = false) {
        self.actionSections = actionSections
        self.position = position
        self.withBlur = withBlur
        self.shouldMoveContentIfNeed = shouldMoveContentIfNeed
    }
}
