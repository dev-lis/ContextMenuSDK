//
//  ContextMenuNavBarItemConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public struct ContextMenuNavBarItemConfig {
    /// Массив  секция для меню
    let actionSections: [ContextMenuSection]
    /// Триггер для отображения контекстного меню
    let trigger: Trigger
    /// Тип бэкграунда
    let backgroudType: BackgroudType
    /// Ширина меню для конкретного контента (если nil, то значение беерться из Settings)
    let menuWidth: CGFloat?
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger = .tap,
                backgroudType: BackgroudType = .color,
                menuWidth: CGFloat? = nil) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.backgroudType = backgroudType
        self.menuWidth = menuWidth
    }
    
    // Нав бар может отображать метю только снизу
    var innerConfig: ContextMenuViewConfig {
        .init(
            actionSections: actionSections,
            trigger: trigger,
            position: .bottomCenter,
            backgroudType: backgroudType,
            menuWidth: menuWidth
        )
    }
}
