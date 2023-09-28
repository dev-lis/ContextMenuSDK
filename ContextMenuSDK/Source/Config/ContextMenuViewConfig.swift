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
    let backgroudType: BackgroudType
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                backgroudType: BackgroudType = .blur,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.backgroudType = backgroudType
        self.menuWidth = menuWidth
    }
    
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: position,
            backgroudType: backgroudType,
            menuWidth: menuWidth,
            shouldMoveContentIfNeed: true
        )
    }
}
