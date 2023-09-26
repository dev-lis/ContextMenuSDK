//
//  ContextMenu.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 23.09.2023.
//

import Foundation

public class ContextMenu {
    
    public static var settings = Settings.shared
    
    private init() {}
    
    private var animationsSettings: Settings.Animations {
        Settings.shared.animations
    }
    
    private var animator: UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: animationsSettings.scaleDuration, curve: .easeOut)
    }
    
    public static func add(to view: UIView,
                           with config: ContextMenuViewConfig) {
        add(to: view, with: config.innerConfig)
    }
    
    static func add(to view: UIView,
                    with config: ContextMenuInnerConfig) {
        let _ = KeyboardHandler.shared
        TransitionHandler.shared.setConfig(config, for: view)
        
        switch config.trigger {
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
    
    public static func add(to barItem: UIBarButtonItem,
                           with config: ContextMenuNavBarItemConfig) {
        DispatchQueue.main.async {
            if let view = barItem.value(forKey: "view") as? UIView {
                BarItemHandler.shared.addViewOnContainerWithContextMenu(
                    view,
                    with: config.innerConfig
                )
            }
        }
    }
    
    public static func add(to barItem: UITabBarItem,
                           with config: ContextMenuTabBarItemConfig) {
        DispatchQueue.main.async {
            if let view = barItem.value(forKey: "view") as? UIView {
                BarItemHandler.shared.addViewOnContainerWithContextMenu(
                    view,
                    with: config.innerConfig
                )
            }
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

