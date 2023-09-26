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
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                withBlur: Bool = true) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.withBlur = withBlur
    }
    
    // Нав бар может отображать метю только снизу
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: .bottomCenter,
            withBlur: withBlur,
            shouldMoveContentIfNeed: false
        )
    }
}
