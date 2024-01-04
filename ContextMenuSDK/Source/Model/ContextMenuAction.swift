//
//  ContextMenuAction.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

public struct ContextMenuAction {
    private let settings = Settings.shared.menuAction
    
    let text: String
    let font: UIFont?
    let textColor: UIColor?
    let image: UIImage?
    let imageColor: UIColor?
    let accessibilityIdentifier: String?
    let action: () -> Void
    
    public init(text: String,
                type: ActionType = .default,
                font: UIFont? = nil,
                textColor: UIColor? = nil,
                image: UIImage? = nil,
                imageColor: UIColor? = nil,
                accessibilityIdentifier: String? = nil,
                action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.font = font ?? settings.font
        
        switch type {
        case .default:
            self.textColor = textColor ?? settings.defaultTextColor
            self.imageColor = imageColor ?? settings.defaultImageColor
        case .negative:
            self.textColor = textColor ?? settings.negativeTextColor
            self.imageColor = imageColor ?? settings.negativeImageColor
        }
    }
    
    public enum ActionType {
        case `default`
        case negative
    }
}
