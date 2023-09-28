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
    let backgroudType: BackgroudType
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                backgroudType: BackgroudType = .color,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.backgroudType = backgroudType
        self.menuWidth = menuWidth
    }
    
    // Нав бар может отображать метю только снизу
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: .bottomCenter,
            backgroudType: backgroudType,
            menuWidth: menuWidth,
            shouldMoveContentIfNeed: false
        )
    }
}
