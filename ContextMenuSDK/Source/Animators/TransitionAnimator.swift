//
//  TransitionAnimator.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

fileprivate var settings = ContextMenuSettings.shared.animations

final class PresentTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let view: UIView
    private let actionSections: [ContextMenuSection]
    private let position: MenuPosition
    
    init(view: UIView,
         actionSections: [ContextMenuSection],
         position: MenuPosition) {
        self.view = view
        self.actionSections = actionSections
        self.position = position
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        settings.showTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? ContextMenuViewController
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let blurEffectView = BlurHandler.createBlur(with: nil)
        containerView.addSubview(blurEffectView)
        
        ViewPositionHandler.shared.replaceViewWithPlaceholder(view: view)
        
        let contentView = ContextMenuContentView(
            content: view,
            actionSections: actionSections,
            position: position
        ) {
            toViewController.dismiss(animated: true)
        }
        
        containerView.addSubview(contentView)
        
        contentView.show()
        
        let animationBlock = {
            blurEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        }
        let completionBlock = {
            containerView.addSubview(toViewController.view)
            toViewController.setContent(contentView)
            blurEffectView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        if let animation = ContextMenuSettings.shared.animations.showBlurAnimation {
            animation((animationBlock, completionBlock))
        } else {
            UIView.animate(
                withDuration: settings.showTransitionDuration,
                animations: {
                    animationBlock()
            }) { _ in
                completionBlock()
            }
        }
    }
}

final class DismissTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        settings.hideTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? ContextMenuViewController,
            let contentView = view.superview as? ContextMenuContentView
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let blurEffectView = BlurHandler.createBlur(with: .systemUltraThinMaterialDark)
        containerView.addSubview(blurEffectView)
        
        if let contentView = view.superview {
            let frameOnWindow = contentView.frameOnWindow
            contentView.frame = frameOnWindow
            containerView.addSubview(contentView)
        }
        
        fromViewController.view.removeFromSuperview()
        
        contentView.hide()
        
        let animationBlock = {
            blurEffectView.effect = nil
        }
        let completionBlock = {
            TransitionHandler.shared.removeActiveView()
            ViewPositionHandler.shared.returnViewBack(view: self.view)
            GesturesHandler.shared.returnLongPress(to: self.view)
            blurEffectView.removeFromSuperview()
            transitionContext.completeTransition(true)
            KeyboardHandler.shared.removeSnapshotIfNeed()
        }
        
        if let animation = ContextMenuSettings.shared.animations.hideBlurAnimation {
            animation((animationBlock, completionBlock))
        } else {
            UIView.animate(
                withDuration: settings.hideTransitionDuration,
                animations: {
                    animationBlock()
            }) { _ in
                completionBlock()
            }
        }
    }
}
