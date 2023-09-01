//
//  UIWindow+Present.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 22.08.2023.
//

import UIKit

extension UIWindow {
    /// Рекурсивно ищем первый жоступный для презентации контроллер
    func firstViewControllerAvailableToPresent(_ controller: UIViewController? = nil) -> UIViewController? {
        let rootController = controller ?? rootViewController
        if let presentedViewController = rootController?.presentedViewController {
            return firstViewControllerAvailableToPresent(presentedViewController)
        } else {
            return rootController
        }
    }
}
