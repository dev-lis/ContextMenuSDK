//
//  ContextMenuNavBarItemConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuNavBarItemConfig {
    let actionSections: [ContextMenuSection]
    let trigger: Trigger
    let withBlur: Bool
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                withBlur: Bool = true,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.withBlur = withBlur
        self.menuWidth = menuWidth
    }
    
    // Нав бар может отображать метю только снизу
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: .bottomCenter,
            withBlur: withBlur,
            menuWidth: menuWidth,
            shouldMoveContentIfNeed: false
        )
    }
}
