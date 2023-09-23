//
//  ContextMenuViewConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuViewConfig {
    let actionSections: [ContextMenuSection]
    let trigger: Trigger
    let position: MenuPosition
    let withBlur: Bool
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                withBlur: Bool = true) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.withBlur = withBlur
    }
    
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: position,
            withBlur: withBlur,
            shouldMoveContentIfNeed: true
        )
    }
}
