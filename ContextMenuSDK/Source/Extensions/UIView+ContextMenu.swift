//
//  UIView+ContextMenu.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

extension UIView {
    
    private var settings: Settings.Animations {
        Settings.shared.animations
    }
    
    var modalScaledFrame: CGRect {
        let modelFrame = layer.model().frame
        return CGRect(
            x: modelFrame.origin.x + settings.scaleFactor,
            y: modelFrame.origin.y + settings.scaleFactor,
            width: modelFrame.width - settings.scaleFactor * 2,
            height: modelFrame.height - settings.scaleFactor * 2
        )
    }
    
    private var presentationScaledFrame: CGRect {
        let presentationFrame = layer.presentation()?.frame ?? .zero
        return CGRect(
            x: presentationFrame.origin.x + settings.scaleFactor,
            y: presentationFrame.origin.y + settings.scaleFactor,
            width: presentationFrame.width - settings.scaleFactor * 2,
            height: presentationFrame.height - settings.scaleFactor * 2
        )
    }
    
    private var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: settings.scaleDuration, curve: .easeOut)
    }
    
    public func addContextMenu(with actionSections: [ContextMenuSection], to position: MenuPosition) {
        let _ = KeyboardHandler.shared
        TransitionHandler.shared.setActions(
            actionSections,
            for: self,
            to: position
        )
        
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleContextMenuPress)
        )
        longPress.cancelsTouchesInView = false
        longPress.minimumPressDuration = 0.01
        
        addGestureRecognizer(longPress)
    }
    
    @objc private func handleContextMenuPress(_ sender: UILongPressGestureRecognizer) {
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
