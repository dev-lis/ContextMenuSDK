//
//  BackgroundContent.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 29.09.2023.
//

import UIKit

public enum BackgroundContent {
    /// Бэкграун с блюром
    case blur(UIVisualEffectView)
    /// Бэкграун с цветным фоном
    case view(UIView)
    /// Без бэкграунда
    case none
}
