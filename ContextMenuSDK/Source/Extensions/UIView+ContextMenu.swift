//
//  UIView+ContextMenu.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

extension UIView {
    
    private var animationsSettings: ContextMenuSettings.Animations {
        ContextMenuSettings.shared.animations
    }
    
    private var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: animationsSettings.scaleDuration, curve: .easeOut)
    }
    
    public func addContextMenu(for action: Trigger = .longPress,
                               with actionSections: [ContextMenuSection],
                               to position: MenuPosition,
                               withBlur: Bool = true,
                               shouldMoveContentIfNeed: Bool = true) {
        let _ = KeyboardHandler.shared
//        TransitionHandler.shared.setActions(
//            actionSections,
//            for: self,
//            to: position,
//            withBlur: withBlur,
//            shouldMoveContentIfNeed: shouldMoveContentIfNeed
//        )
        
        switch action {
        case .tap:
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuTap)
            )
            tap.cancelsTouchesInView = false
            
            addGestureRecognizer(tap)
        case .longPress:
            let longPress = UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuLongPress)
            )
            longPress.cancelsTouchesInView = false
            longPress.minimumPressDuration = 0.01
            
            addGestureRecognizer(longPress)
        }
    }
    
    @objc private func handleContextMenuTap(_ sender: UITapGestureRecognizer) {
        GesturesHandler.shared.removeGesture(sender)
        openContextMenu()
    }
    
    @objc private func handleContextMenuLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            ScaleAnimator.scale(self) {
                GesturesHandler.shared.removeGesture(sender)
                self.openContextMenu()
            }
        case .ended, .cancelled:
            ScaleAnimator.cancel()
        default:
            return
        }
    }
    
    private func openContextMenu() {
        FeedbackGenerator.generateFeedback(type: .impact(feedbackStyle: .medium))
        KeyboardHandler.shared.saveFirstResponderIfNeed()
        TransitionHandler.shared.setActiveView(self)
        
        let withBlur = TransitionHandler.shared.getBlurValue(for: self)
        let controller = ContextMenuViewController(withBlur: withBlur)
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.transitioningDelegate = TransitionHandler.shared
        window?.firstViewControllerAvailableToPresent()?.present(controller, animated: true)
    }
}

extension UIView {
    var frameOnWindow: CGRect {
        superview?.convert(frame, to: nil) ?? .zero
    }
}
