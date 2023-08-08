//
//  Screen.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

enum Screen {
    enum SafeArea {
        static var top: CGFloat {
            return UIApplication.shared.windows
                .first { $0.isKeyWindow }?
                .safeAreaInsets
                .top ?? .zero
        }
        
        static var bottom: CGFloat {
            return UIApplication.shared.windows
                .first { $0.isKeyWindow }?
                .safeAreaInsets
                .bottom ?? .zero
        }
        
        static var left: CGFloat {
            return UIApplication.shared.windows
                .first { $0.isKeyWindow }?
                .safeAreaInsets
                .left ?? .zero
        }
        
        static var right: CGFloat {
            return UIApplication.shared.windows
                .first { $0.isKeyWindow }?
                .safeAreaInsets
                .right ?? .zero
        }
    }
}
