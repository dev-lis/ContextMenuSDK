//
//  TransitionAnimator.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

fileprivate var settings = Settings.shared.animations

final class PresentTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let view: UIView
    private let config: ContextMenuInnerConfig
    
    init(view: UIView,
         config: ContextMenuInnerConfig) {
        self.view = view
        self.config = config
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
        
        let backgroundContent: BackgroundContent
        let backgroundCompletion: (() -> Void)?
        switch config.backgroudType {
        case .blur:
            let blurEffectView = BlurHandler.createBlur(with: nil)
            containerView.addSubview(blurEffectView)
            backgroundContent = .blur(blurEffectView)
            backgroundCompletion = {
                blurEffectView.effect = UIBlurEffect(style: settings.blurStyle)
            }
        case .color:
            let backgroundView = UIView(frame: containerView.frame)
            backgroundContent = .view(backgroundView)
            backgroundCompletion = {
                backgroundView.backgroundColor = settings.backgroundColor
            }
        case .none:
            backgroundContent = .none
            backgroundCompletion = nil
        }
        
        ViewPositionHandler.shared.replaceViewWithPlaceholder(view: view)
        
        let contentView = ContextMenuContentView(
            content: view,
            actionSections: config.actionSections,
            position: config.position,
            menuWidth: config.menuWidth
        ) {
            toViewController.dismiss(animated: true)
        }
        
        containerView.addSubview(contentView)
        
//        if config.shouldMoveContentIfNeed {
            contentView.moveToNewPositionIfNeed()
//        }
        
        let completion = {
            containerView.addSubview(toViewController.view)
            toViewController.setContent(
                contentView,
                with: backgroundContent,
                for: self.config.position
            )
            transitionContext.completeTransition(true)
        }
        
        if let animation = settings.showAnimation {
            animation(
                backgroundContent,
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
                    backgroundCompletion?()
            }) { _ in
                completion()
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
        
        let backgroundContent = fromViewController.backgroundContent
        let backgroundCompletion: (() -> Void)?
        switch backgroundContent {
        case let .blur(blur):
            containerView.addSubview(blur)
            backgroundCompletion = {
                blur.effect = nil
            }
        case let .view(view):
            containerView.addSubview(view)
            backgroundCompletion = {
                view.backgroundColor = .clear
            }
        case .none:
            backgroundCompletion = nil
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
            GesturesHandler.shared.returnGesture(to: self.view)
            transitionContext.completeTransition(true)
            KeyboardHandler.shared.becomeFirstResponderIfNeed()
        }
        
        if let animation = settings.hideAnimation {
            animation(
                backgroundContent,
                contentView.content,
                contentView.menuView,
                completion
            )
        } else {
            UIView.animate(
                withDuration: settings.hideTransitionDuration,
                animations: {
                    backgroundCompletion?()
                    contentView.hide()
            }) { _ in
                completion()
            }
        }
    }
}
