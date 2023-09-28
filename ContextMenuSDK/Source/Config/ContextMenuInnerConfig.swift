//
//  ContextMenuInnerConfig.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

struct ContextMenuInnerConfig {
    /// Массив  секция для меню
    let actionSections: [ContextMenuSection]
    /// Триггер для отображения контекстного меню
    let trigger: Trigger
    /// Позиция меню по отношению к контенту
    let position: MenuPosition
    /// Тип бэкграунда/
    let backgroudType: BackgroudType
    /// Ширина меню для конкретного контента (если nil, то значение беерться из Settings)
    let menuWidth: CGFloat?
    let shouldMoveContentIfNeed: Bool
    
    public init(actionSections: [ContextMenuSection],
                trigger: Trigger,
                position: MenuPosition,
                backgroudType: BackgroudType,
                menuWidth: CGFloat?,
                shouldMoveContentIfNeed: Bool) {
        self.actionSections = actionSections
        self.trigger = trigger
        self.position = position
        self.backgroudType = backgroudType
        self.menuWidth = menuWidth
        self.shouldMoveContentIfNeed = shouldMoveContentIfNeed
    }
}
