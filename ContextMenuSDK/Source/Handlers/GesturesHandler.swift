//
//  GesturesHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 04.05.2023.
//

import UIKit

final class GesturesHandler {
    
    static let shared = GesturesHandler()
    
    private var longPress: UILongPressGestureRecognizer?
    private weak var view: UIView?
    
    private var gestures: [UIView: UILongPressGestureRecognizer] = [:]
    
    private init() {}
    
    /// Чтобы при открытом меню вьюшка не реагированла на лонгтапы, сохраняем этот жест и удаляем его с вьюшки
    func removeLongPress(_ longPress: UILongPressGestureRecognizer) {
        guard let view = longPress.view else {
            return
        }
        gestures[view] = longPress
        view.removeGestureRecognizer(longPress)
    }
    
    /// Когда контекстное меню закрывается лонгтап снова нужно добавить на вью
    func returnLongPress(to view: UIView) {
        guard let longPress = gestures[view] else {
            return
        }
        view.addGestureRecognizer(longPress)
    }
}
