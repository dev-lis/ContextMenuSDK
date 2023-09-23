//
//  TransitionHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

fileprivate struct MenuModel {
    let actionSections: [ContextMenuSection]
    let position: MenuPosition
    let withBlur: Bool
    let shouldMoveContentIfNeed: Bool
}

final class TransitionHandler: NSObject {
    
    static let shared = TransitionHandler()
    
    private var view: UIView?
    private var models: [UIView: MenuModel] = [:]
    private var configs: [UIView: ContextMenuConfig] = [:]
    
    private override init() {}
    
    /// Набор экшенов и позиция для каждой вью устанавливается,
    /// когда вылывается метод addContextMenu(), поэтому их нужно сохранить локально&
    /// для каждой вью по отдельности
    func setActions(_ actionSections: [ContextMenuSection],
                    for view: UIView,
                    to position: MenuPosition,
                    withBlur: Bool,
                    shouldMoveContentIfNeed: Bool) {
        self.models[view] = MenuModel(
            actionSections: actionSections,
            position: position,
            withBlur: withBlur,
            shouldMoveContentIfNeed: shouldMoveContentIfNeed
        )
    }
    
    func setConfig(_ config: ContextMenuConfig,
                   for view: UIView) {
        self.configs[view] = config
    }
    
    /// Метод вызывается перед тем как запуститься нанимация перехода,
    /// для того чтобы можно было получить набор экшенов и позицию меню, конкретной вьюшки
    func setActiveView(_ view: UIView) {
        self.view = view
    }
    
    /// Метод вызывается когда контекстное меню закрывается
    func removeActiveView() {
        view = nil
    }
    
    func getBlurValue(for view: UIView) -> Bool {
        guard let model = models[view] else {
            return false
        }
        return model.withBlur
    }
}

extension TransitionHandler: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let view = view,
            let config = configs[view]
        else {
            return nil
        }
        return PresentTransitionAnimator(view: view, config: config)
    }

    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let view,
            let config = configs[view]
        else {
            return nil
        }
        return DismissTransitionAnimator(
            view: view,
            withBlur: config.withBlur,
            shouldMoveContentIfNeed: config.shouldMoveContentIfNeed
        )
    }
}
