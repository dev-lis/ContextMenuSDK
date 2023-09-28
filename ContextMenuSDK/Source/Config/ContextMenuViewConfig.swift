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
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                withBlur: Bool = true,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.withBlur = withBlur
        self.menuWidth = menuWidth
    }
    
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: position,
            withBlur: withBlur,
            menuWidth: menuWidth,
            shouldMoveContentIfNeed: true
        )
    }
}
