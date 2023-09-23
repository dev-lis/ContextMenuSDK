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
        
        let scaleFactor = Settings.shared.animations.scaleFactor
        
        let scaledX = 1 - view.frame.width * scaleFactor / view.frame.width
        let scaledY = 1 - view.frame.height * scaleFactor / view.frame.height
        
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
