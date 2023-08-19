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
    private let withBlur: Bool
    
    init(view: UIView,
         actionSections: [ContextMenuSection],
         position: MenuPosition,
         withBlur: Bool) {
        self.view = view
        self.actionSections = actionSections
        self.position = position
        self.withBlur = withBlur
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
        
        contentView.moveToNewPositionIfNeed()
        
        let completion = {
            containerView.addSubview(toViewController.view)
            toViewController.setContent(
                contentView,
                with: self.withBlur ? blurEffectView : nil)
            transitionContext.completeTransition(true)
        }
        
        if let animation = settings.showAnimation {
            animation(
                blurEffectView,
                contentView.content,
                contentView.menuView,
                completion
            )
        } else {
            UIView.animate(
                withDuration: settings.showTransitionDuration,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 5,
                options: .curveEaseInOut)
            {
                contentView.show()
            }
            UIView.animate(
                withDuration: settings.showTransitionDuration,
                animations: {
                    if self.withBlur {
                        blurEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
                    }
            }) { _ in
                completion()
            }
        }
    }
}

final class DismissTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let view: UIView
    private let withBlur: Bool
    
    init(view: UIView,
         withBlur: Bool) {
        self.view = view
        self.withBlur = withBlur
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        settings.hideTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? ContextMenuViewController,
            // контент складывается в дополнительный контейнер, чтобы коректно отрабатывали UIBarItems
            let contentView = view.superview?.superview as? ContextMenuContentView
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let blurEffectView = fromViewController.blurEffectView
        if let blurEffectView = blurEffectView {
            containerView.addSubview(blurEffectView)
        }
        
        if let contentView = view.superview {
            let frameOnWindow = contentView.frameOnWindow
            contentView.frame = frameOnWindow
            containerView.addSubview(contentView)
        }
        
        fromViewController.view.removeFromSuperview()
        
        contentView.moveToStartPositionIfNeed()

        let completion = {
            TransitionHandler.shared.removeActiveView()
            ViewPositionHandler.shared.returnViewBack(view: self.view)
            GesturesHandler.shared.returnLongPress(to: self.view)
            blurEffectView?.removeFromSuperview()
            transitionContext.completeTransition(true)
            KeyboardHandler.shared.removeSnapshotIfNeed()
        }
        
        if let animation = settings.hideAnimation {
            animation(
                blurEffectView,
                contentView.content,
                contentView.menuView,
                completion
            )
        } else {
            UIView.animate(
                withDuration: settings.hideTransitionDuration,
                animations: {
                    blurEffectView?.effect = nil
                    contentView.hide()
            }) { _ in
                completion()
            }
        }
    }
}
