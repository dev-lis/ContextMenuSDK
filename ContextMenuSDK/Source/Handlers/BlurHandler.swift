//
//  BlurHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 03.05.2023.
//

import UIKit

enum BlurHandler {
    static func createBlur(with style: UIBlurEffect.Style?) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let style = style {
            blurEffectView.effect = UIBlurEffect(style: style)
        }
        return blurEffectView
    }
}
