//
//  UITabBarItem+ContextMenu.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 29.08.2023.
//

import UIKit

extension UITabBarItem {
    
    public convenience init(image: UIImage,
                            title: String?,
                            with actionSections: [ContextMenuSection],
                            to position: MenuPosition,
                            withBlur: Bool = true) {
        self.init(
            title: title,
            image: image,
            tag: 0
        )
        addContextMenu(
            for: .longPress,
            with: actionSections,
            to: position,
            withBlur: withBlur
        )
    }
    
    func addContextMenu(for action: TriggerType = .longPress,
                        with actionSections: [ContextMenuSection],
                        to position: MenuPosition,
                        withBlur: Bool = true) {
        DispatchQueue.main.async {
            if let view = self.value(forKey: "view") as? UIView {
                BarItemHandler.shared.addViewOnContainerWithContextMenu(
                    view,
                    for: action,
                    with: actionSections,
                    to: position,
                    withBlur: withBlur
                )
            }
        }
    }
}
