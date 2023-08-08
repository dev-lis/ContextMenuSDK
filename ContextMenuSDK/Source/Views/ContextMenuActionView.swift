//
//  ContextMenuActionView.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

final class ContextMenuActionView: UIView {
    
    private var settings = Settings.shared.menuAction
    
    private let action: () -> Void
    private let completion: () -> Void
    
    init(action: ContextMenuAction,
         completion: @escaping () -> Void) {
        self.action = action.action
        self.completion = completion
        super.init(frame: .zero)
        setup(with: action)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(with action: ContextMenuAction) {
        backgroundColor = settings.defaultBackgroundColor
        
        var imageView: UIImageView?
        if let image = action.image {
            imageView = UIImageView()
            imageView?.frame = CGRect(
                x: settings.width - settings.imageSize - settings.indentLeftAndRight,
                y: 0,
                width: settings.imageSize,
                height: settings.imageSize
            )
            imageView?.contentMode = .scaleAspectFill
            if let color = action.imageColor {
                imageView?.image = image.withRenderingMode(.alwaysTemplate)
                imageView?.tintColor = color
            } else {
                imageView?.image = image
            }
            addSubview(imageView!)
        }
        
        let leftImageInset = imageView == nil
        ? settings.indentLeftAndRight
        : settings.indentLeftAndRight * 2 + settings.imageSize
        let labelFrame = CGRect(
            x: settings.indentLeftAndRight,
            y: settings.insetOfTopAndBottom,
            width: settings.width - settings.indentLeftAndRight - leftImageInset,
            height: 0
        )
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.text = action.text
        label.font = action.font
        label.textColor = action.textColor
        label.sizeToFit()
        addSubview(label)
        
        frame.size = CGSize(
            width: settings.width,
            height: label.frame.height + settings.insetOfTopAndBottom * 2
        )
        
        imageView?.frame.origin = CGPoint(
            x: settings.width - settings.imageSize - settings.indentLeftAndRight,
            y: center.y - settings.imageSize / 2
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc private func didTap() {
        action()
        completion()
    }
}
