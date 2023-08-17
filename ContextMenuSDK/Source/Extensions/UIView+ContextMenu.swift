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
    
    var modalScaledFrame: CGRect {
        let modelFrame = layer.model().frame
        return CGRect(
            x: modelFrame.origin.x + animationsSettings.scaleFactor,
            y: modelFrame.origin.y + animationsSettings.scaleFactor,
            width: modelFrame.width - animationsSettings.scaleFactor * 2,
            height: modelFrame.height - animationsSettings.scaleFactor * 2
        )
    }
    
    private var presentationScaledFrame: CGRect {
        let presentationFrame = layer.presentation()?.frame ?? .zero
        return CGRect(
            x: presentationFrame.origin.x + animationsSettings.scaleFactor,
            y: presentationFrame.origin.y + animationsSettings.scaleFactor,
            width: presentationFrame.width - animationsSettings.scaleFactor * 2,
            height: presentationFrame.height - animationsSettings.scaleFactor * 2
        )
    }
    
    private var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: animationsSettings.scaleDuration, curve: .easeOut)
    }
    
    public func addContextMenu(for action: ActionType = .longPress,
                               with actionSections: [ContextMenuSection],
                               to position: MenuPosition,
                               withBlur: Bool = true) {
        let _ = KeyboardHandler.shared
        TransitionHandler.shared.setActions(
            actionSections,
            for: self,
            to: position,
            withBlur: withBlur
        )
        
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
        openContextMenu()
    }
    
    @objc private func handleContextMenuLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            ScaleAnimator.scale(self) {
                GesturesHandler.shared.removeLongPress(sender)
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
        KeyboardHandler.shared.addSnapshotIfNeed()
        TransitionHandler.shared.setActiveView(self)
        
        let controller = ContextMenuViewController()
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.transitioningDelegate = TransitionHandler.shared
        window?.rootViewController?.present(controller, animated: true)
    }
}

extension UIView {
    var frameOnWindow: CGRect {
        superview?.convert(frame, to: nil) ?? .zero
    }
}
