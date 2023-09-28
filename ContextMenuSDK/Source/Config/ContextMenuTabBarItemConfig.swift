//
//  ContextMenuTabBarItemConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuTabBarItemConfig {
    let actionSections: [ContextMenuSection]
    /// Тип бэкграунда
    let backgroudType: BackgroudType
    /// Ширина меню для конкретного контента (если nil, то значение беерться из Settings)
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                backgroudType: BackgroudType = .blur,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.backgroudType = backgroudType
        self.menuWidth = menuWidth
    }
    
    // Таб бар может обрабатывать только longPress и отображать метю только сверху
    var innerConfig: ContextMenuInnerConfig {
        .init(
            actionSections: actionSections,
            trigger: .longPress,
            position: .topCenter,
            backgroudType: backgroudType,
            menuWidth: menuWidth
        )
    }
}
