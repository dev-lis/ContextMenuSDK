//
//  ContextMenuActionView.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

final class ContextMenuActionView: UIView {
    
    private var menuSettings = Settings.shared.menu
    private var menuActionSettings = Settings.shared.menuAction
    
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
        backgroundColor = menuActionSettings.defaultBackgroundColor
        
        var imageView: UIImageView?
        if let image = action.image {
            imageView = UIImageView()
            imageView?.frame = CGRect(
                x: menuSettings.width - menuActionSettings.imageSize - menuActionSettings.insetOfLeftAndRight,
                y: 0,
                width: menuActionSettings.imageSize,
                height: menuActionSettings.imageSize
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
        ? menuActionSettings.insetOfLeftAndRight
        : menuActionSettings.insetOfLeftAndRight * 2 + menuActionSettings.imageSize
        let labelFrame = CGRect(
            x: menuActionSettings.insetOfLeftAndRight,
            y: menuActionSettings.insetOfTopAndBottom,
            width: menuSettings.width - menuActionSettings.insetOfLeftAndRight - leftImageInset,
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
            width: menuSettings.width,
            height: label.frame.height + menuActionSettings.insetOfTopAndBottom * 2
        )
        
        imageView?.frame.origin = CGPoint(
            x: menuSettings.width - menuActionSettings.imageSize - menuActionSettings.insetOfLeftAndRight,
            y: center.y - menuActionSettings.imageSize / 2
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
