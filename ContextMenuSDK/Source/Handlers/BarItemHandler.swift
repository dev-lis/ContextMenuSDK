//
//  BarItemHandler.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 21.08.2023.
//

import UIKit

/// Чтобы UIBarButtonItem могли обрабатывать контекстное меню,
/// сам контент (Image или title) нужно завернуть в контейнер вью,
/// котрый и будет обрабатывать контекстное меню.
///
/// При сворачивании приложения структура NavigationBar пересобирается и контейнер удаляется.
/// Поэтому BarItem теряет возможность обрабатывать контекстное меню.
/// Для этого необходимо сохранить все вьюшки и данных контекстного меню,
/// а при открытии приложения снова добавить добавить контейнер с контекстным меню в структуру

class BarItemHandler {
    
    static let shared = BarItemHandler()
    
    private var configs = [Weak<UIView>: ContextMenuViewConfig]()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appWillEnterForeground() {
        configs.forEach {
            guard let view = $0.key.object else {
                return
            }
            let config = $0.value
            addViewOnContainerWithContextMenu(
                view,
                with: config
            )
        }
    }
    
    func addViewOnContainerWithContextMenu(_ view: UIView,
                                           with config: ContextMenuViewConfig) {
        if view.superview is BarContainerView {
            return
        }
        
        let containerView = BarContainerView(frame: view.frame)
        view.superview?.addSubview(containerView)
        containerView.addSubview(view)
        
        configs.forEach {
            if $0.key.object == nil {
                configs[$0.key] = nil
            }
        }
        configs[Weak(view)] = config
        
        ContextMenu.add(
            to: containerView,
            with: config
        )
    }
}

class BarContainerView: UIView {
    
    private var observer: NSKeyValueObservation?
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        observer = subviews.first?.observe(\.frame) { object, _ in
            guard object.frame.origin != .zero else {
                return
            }
            object.frame.origin = .zero
        }
    }
}
