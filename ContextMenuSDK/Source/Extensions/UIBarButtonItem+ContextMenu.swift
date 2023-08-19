//
//  UIBarButtonItem+ContextMenu.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 19.08.2023.
//

import UIKit

extension UIBarButtonItem {
    public func addContextMenu(for action: ActionType = .longPress,
                               with actionSections: [ContextMenuSection],
                               to position: MenuPosition,
                               withBlur: Bool = true) {
        if let view = value(forKey: "view") as? UIView {
            DispatchQueue.main.async {
                let containerView = UIView(frame: view.bounds)
                view.superview?.addSubview(containerView)
                containerView.addSubview(view)
                containerView.addContextMenu(
                    for: action,
                    with: actionSections,
                    to: position,
                    withBlur: withBlur,
                    shouldMoveContentIfNeed: false
                )
            }
        }
    }
}
