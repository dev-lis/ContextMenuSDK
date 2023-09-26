//
//  ContextMenuTabBarItemConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuTabBarItemConfig {
    let actionSections: [ContextMenuSection]
    let withBlur: Bool
    
    public init(actionSections: [ContextMenuSection],
                withBlur: Bool = true) {
        self.actionSections = actionSections
        self.withBlur = withBlur
    }
    
    // Таб бар может обрабатывать только longPress и отображать метю только сверху
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: .longPress,
            position: .topCenter,
            withBlur: withBlur,
            shouldMoveContentIfNeed: false
        )
    }
}
