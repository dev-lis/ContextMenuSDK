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
        
        // нужно включить перед анимацией, наче анимация работает криво
        let scaleFactorX = (view.frame.width - Settings.shared.animations.scaleFactor * 2) / view.frame.width
        let scaleFactorY = (view.frame.height - Settings.shared.animations.scaleFactor * 2) / view.frame.height
        animator.addAnimations {
            view.transform = CGAffineTransform(scaleX: scaleFactorX, y: scaleFactorY)
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
