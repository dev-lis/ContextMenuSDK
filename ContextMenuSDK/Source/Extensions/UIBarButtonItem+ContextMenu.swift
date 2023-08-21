//
//  UIBarButtonItem+ContextMenu.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 19.08.2023.
//

import UIKit

extension UIBarButtonItem {
    public convenience init(image: UIImage,
                            for action: ActionType = .longPress,
                            with actionSections: [ContextMenuSection],
                            to position: MenuPosition,
                            withBlur: Bool = true) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: image.size))
        imageView.image = image
        self.init(customView: imageView)
        addContextMenu(
            for: action,
            with: actionSections,
            to: position,
            withBlur: withBlur
        )
    }
    
    public convenience init(title: String,
                            font: UIFont = .systemFont(ofSize: 17),
                            color: UIColor = .systemBlue,
                            for action: ActionType = .longPress,
                            with actionSections: [ContextMenuSection],
                            to position: MenuPosition,
                            withBlur: Bool = true) {
        
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        label.sizeToFit()
        self.init(customView: label)
        addContextMenu(
            for: action,
            with: actionSections,
            to: position,
            withBlur: withBlur
        )
    }
    
    private func addContextMenu(for action: ActionType = .longPress,
                                with actionSections: [ContextMenuSection],
                                to position: MenuPosition,
                                withBlur: Bool = true) {
        if let view = value(forKey: "view") as? UIView {
            DispatchQueue.main.async {
                BarItemHandler.shared.addViewOnContainerWithContextMenu(
                    view,
                    for: action,
                    with: actionSections,
                    to: position,
                    withBlur: withBlur)
            }
        }
    }
}