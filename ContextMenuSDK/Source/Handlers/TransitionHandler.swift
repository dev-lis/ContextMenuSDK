//
//  TransitionHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

final class TransitionHandler: NSObject {
    
    static let shared = TransitionHandler()
    
    private var view: UIView?
    private var configs: [Weak<UIView>: ContextMenuInnerConfig] = [:]
    
    private override init() {}
    
    /// Конфиги для каждой вью устанавливается,
    /// когда вылывается метод addContextMenu(), поэтому их нужно сохранить локально,
    /// для каждой вью по отдельности
    func setConfig(_ config: ContextMenuInnerConfig,
                   for view: UIView) {
        self.configs[Weak(view)] = config
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
        guard let model = configs.first(where: { $0.key.object == view })?.value else {
            return false
        }
        return model.backgroudType == .blur
    }
}

extension TransitionHandler: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let view = view,
            let config = configs.first(where: { $0.key.object == view })?.value
        else {
            return nil
        }
        return PresentTransitionAnimator(view: view, config: config)
    }

    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let view,
            let config = configs.first(where: { $0.key.object == view })?.value
        else {
            return nil
        }
        return DismissTransitionAnimator(
            view: view,
            shouldMoveContentIfNeed: config.shouldMoveContentIfNeed
        )
    }
}
