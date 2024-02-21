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
                           on triggerView: UIView? = nil,
                           with config: ContextMenuViewConfig) {
        let _ = KeyboardHandler.shared
        TransitionHandler.shared.setConfig(config, for: view)
        if let triggerView {
            TriggerViewHandler.shared.setView(view, for: triggerView)
        }
        
        let gestueView = triggerView ?? view
        gestueView.isUserInteractionEnabled = true
        
        /// Если используется TriggerView  то событие обрабатывается только по тапу
        if triggerView != nil || config.trigger == .tap {
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuTap)
            )
            tap.cancelsTouchesInView = false
            
            gestueView.addGestureRecognizer(tap)
        } else if config.trigger == .longPress {
            let longPress = UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleContextMenuLongPress)
            )
            longPress.cancelsTouchesInView = false
            longPress.minimumPressDuration = 0.01
            
            gestueView.addGestureRecognizer(longPress)
        }
    }
    
    public static func add(to barItem: UIBarButtonItem,
                           with config: ContextMenuNavBarItemConfig) {
        DispatchQueue.main.async {
            /// Может быть ситуация, когда контекстное меню добавляется, до того, как сформирован стек навигации
            /// Поэтому ставим даймер и ждем когда стек появится
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if let view = barItem.value(forKey: "view") as? UIView {
                    timer.invalidate()
                    BarItemHandler.shared.addViewOnContainerWithContextMenu(
                        view,
                        with: config.innerConfig
                    )
                }
            }
        }
    }
    
    public static func add(to barItem: UITabBarItem,
                           with config: ContextMenuTabBarItemConfig) {
        DispatchQueue.main.async {
            /// Может быть ситуация, когда контекстное меню добавляется, до того, как сформирован стек навигации
            /// Поэтому ставим даймер и ждем когда стек появится
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if let view = barItem.value(forKey: "view") as? UIView {
                    timer.invalidate()
                    BarItemHandler.shared.addViewOnContainerWithContextMenu(
                        view,
                        with: config.innerConfig
                    )
                }
            }
        }
    }
    
    @objc static private func handleContextMenuTap(_ sender: UITapGestureRecognizer) {
        guard let gestureView = sender.view else {
            return
        }
        
        /// Если тап был по TriggerView,
        /// То нужно брать жест с ContentView
        let contentView = TriggerViewHandler.shared.getContentView(for: gestureView)
        contentView.gestureRecognizers?.forEach {
            guard $0 is UITapGestureRecognizer || $0 is UILongPressGestureRecognizer else {
                return
            }
            GesturesHandler.shared.removeGesture($0)
        }
        
        GesturesHandler.shared.removeGesture(sender)
        openContextMenu(for: contentView)
    }
    
    @objc static private func handleContextMenuLongPress(_ sender: UILongPressGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        
        let contentView = TriggerViewHandler.shared.getContentView(for: view)
        
        switch sender.state {
        case .began:
            ScaleAnimator.scale(contentView) {
                GesturesHandler.shared.removeGesture(sender)
                openContextMenu(for: contentView)
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

