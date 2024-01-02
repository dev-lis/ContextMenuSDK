//
//  ScaleAnimator.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 03.05.2023.
//

import UIKit

enum ScaleAnimator {
    static private var animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut)
    
    static func scale(_ view: UIView, completion: @escaping () -> Void) {
        
        let scaleValue = Settings.shared.animations.scaleValue
        let scaleFactor = Settings.shared.animations.scaleFactor
        
        let xValue = (view.bounds.width - scaleValue * 2) / view.bounds.width
        let yValue = (view.bounds.height - scaleValue * 2) / view.bounds.height
        let value = max(xValue, yValue)
        
        /// Для болиш вью используется scaleValue, для уменьшения каждой стороны
        /// Если на которое нужно заскейлить вью превышает scaleFactor (в относительном значении)
        /// Тогда вычисляем знаение для сейла от scaleFactor (применятся для маленьких вью)
        let scaledX: CGFloat
        let scaledY: CGFloat
        if value < 1 - scaleFactor {
            scaledX = 1 - view.frame.width * scaleFactor / view.frame.width
            scaledY = 1 - view.frame.height * scaleFactor / view.frame.height
        } else {
            scaledX = value
            scaledY = value
        }
        
        animator.addAnimations {
            view.transform = CGAffineTransform(scaleX: scaledX, y: scaledY)
        }
        animator.addCompletion {
            view.translatesAutoresizingMaskIntoConstraints = false
            guard $0 else { return }
            completion()
        }
        animator.startAnimation()
    }
    
    static func cancel() {
        animator.isReversed = true
    }
}

extension UIViewPropertyAnimator {
    func addCompletion(_ completion: @escaping (Bool) -> Void) {
        addCompletion { position in
            completion(position == .end)
        }
    }
}
