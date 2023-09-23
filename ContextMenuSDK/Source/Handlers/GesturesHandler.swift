//
//  GesturesHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

final class GesturesHandler {
    
    static let shared = GesturesHandler()
    
    private weak var view: UIView?
    
    private var gestures: [UIView: UIGestureRecognizer] = [:]
    
    private init() {}
    
    /// Чтобы при открытом меню вьюшка не реагированла на жест, который ее открывает, сохраняем этот жест и удаляем его с вьюшки
    func removeGesture(_ gesture: UIGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        gestures[view] = gesture
        view.removeGestureRecognizer(gesture)
    }
    
    /// Когда контекстное меню закрывается, поэтому исходный жест нужно снова добавить на вью
    func returnGesture(to view: UIView) {
        guard let gesture = gestures[view] else {
            return
        }
        view.addGestureRecognizer(gesture)
    }
}
