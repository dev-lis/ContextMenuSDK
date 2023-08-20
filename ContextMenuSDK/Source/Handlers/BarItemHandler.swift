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
    
    private struct Model {
        let action: ActionType
        let actionSections: [ContextMenuSection]
        let position: MenuPosition
        let withBlur: Bool
    }
    
    static let shared = BarItemHandler()
    
    private var viewModels = [UIView: Model]()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appWillEnterForeground() {
        viewModels.forEach {
            let view = $0.key
            let model = $0.value
            addViewOnContainerWithContextMenu(
                view,
                for: model.action,
                with: model.actionSections,
                to: model.position,
                withBlur: model.withBlur
            )
        }
    }
    
    func addViewOnContainerWithContextMenu(_ view: UIView,
                                           for action: ActionType,
                                           with actionSections: [ContextMenuSection],
                                           to position: MenuPosition,
                                           withBlur: Bool) {
        let containerView = UIView(frame: view.bounds)
        view.superview?.addSubview(containerView)
        containerView.addSubview(view)
        
        viewModels[view] = Model(
            action: action,
            actionSections: actionSections,
            position: position,
            withBlur: withBlur
        )
        
        containerView.addContextMenu(
            for: action,
            with: actionSections,
            to: position,
            withBlur: withBlur,
            shouldMoveContentIfNeed: false
        )
    }
}
