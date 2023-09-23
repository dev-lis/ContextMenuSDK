//
//  ContextMenu.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public class ContextMenu {
    
    private init() {}
    
    private var animationsSettings: ContextMenuSettings.Animations {
        ContextMenuSettings.shared.animations
    }
    
    private var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: animationsSettings.scaleDuration, curve: .easeOut)
    }
    
    public static func add(to view: UIView,
                           for trigger: TriggerType,
                           with config: ContextMenuConfig) {
        let _ = KeyboardHandler.shared
        TransitionHandler.shared.setConfig(config, for: view)
        
        switch trigger {
        case .tap:
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuTap)
            )
            tap.cancelsTouchesInView = false
            
            view.addGestureRecognizer(tap)
        case .longPress:
            let longPress = UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuLongPress)
            )
            longPress.cancelsTouchesInView = false
            longPress.minimumPressDuration = 0.01
            
            view.addGestureRecognizer(longPress)
        }
    }
    
    @objc static private func handleContextMenuTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        
        GesturesHandler.shared.removeGesture(sender)
        openContextMenu(for: view)
    }
    
    @objc static private func handleContextMenuLongPress(_ sender: UILongPressGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        
        switch sender.state {
        case .began:
            ScaleAnimator.scale(view) {
                GesturesHandler.shared.removeGesture(sender)
                openContextMenu(for: view)
            }
        case .ended, .cancelled:
            ScaleAnimator.cancel()
        default:
            return
        }
    }
    
    private static func openContextMenu(for view: UIView) {
        FeedbackGenerator.generateFeedback(type: .impact(feedbackStyle: .medium))
        KeyboardHandler.shared.saveFirstResponderIfNeed()
        TransitionHandler.shared.setActiveView(view)
        
        let withBlur = TransitionHandler.shared.getBlurValue(for: view)
        let controller = ContextMenuViewController(withBlur: withBlur)
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.transitioningDelegate = TransitionHandler.shared
        view.window?.firstViewControllerAvailableToPresent()?.present(controller, animated: true)
    }
}

