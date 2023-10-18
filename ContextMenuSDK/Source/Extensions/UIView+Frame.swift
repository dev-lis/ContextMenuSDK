//
//  UIView+Frame.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

extension UIView {
    var frameOnWindow: CGRect {
        superview?.convert(frame, to: nil) ?? .zero
    }
}
