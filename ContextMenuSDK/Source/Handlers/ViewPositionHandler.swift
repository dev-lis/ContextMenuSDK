//
//  ViewPositionHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 02.05.2023.
//

import UIKit

final class ViewPositionHandler {
    
    static let shared = ViewPositionHandler()
    
    private var placeholderView: UIView?
    private var position: CGPoint?
    private var translatesAutoresizingMaskIntoConstraints = true
    
    private init() {}
    
    /// Если вью находится в скрол вью и скрол зависит от клавиатуры (например чат)
    /// Нужно сохранить положение вью на экране, до того как будет свернута клавиатура.
    func saveViewPosition(view: UIView) {
        position = view.frameOnWindow.origin
    }

    /// Получаем сохраненное положение
    func getViewPosition() -> CGPoint {
        position ?? .zero
    }
    
    /// Если используется Autolayout, то при перенесении вью,
    /// которая будет отображаться на контекстном меню лэйаут сломается.
    /// Поэтому на время добавляем зглушку, которая будет держать лэйаут
    ///
    /// 1. Создаем прозрачную вьюшку с таким же фреймом (плейсхолдер)
    /// 2. Добавляем на плейсхолер на родительское вью нашего контента
    /// 3. Копируем контстрейны с контента на плейсхолдер
    /// 4. Удаляем скопированные констрейнты с контент
    /// 5. Сохраняем свойство translatesAutoresizingMaskIntoConstraints.
    /// * Если его отавить false, при переходе лэйаут контента будет криво отрабатыва.
    /// 6. Устанавливаем translatesAutoresizingMaskIntoConstraints true
    func replaceViewWithPlaceholder(view: UIView) {
        let placeholderView = UIView(frame: view.frame)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        self.placeholderView = placeholderView
        
        view.superview?.addSubview(placeholderView)
        placeholderView.copyConstraints(from: view)
        
        let widthDiff = (view.bounds.width - view.frame.width) / 2
        let heightDiff = (view.bounds.height - view.frame.height) / 2
        let origin = CGPoint(
            x: view.frame.origin.x - widthDiff,
            y: view.frame.origin.y - heightDiff
        )
        placeholderView.frame = CGRect(
            origin: origin,
            size: view.bounds.size
        )
        
        var sourceViewСonstraints = [NSLayoutConstraint]()
        view.superview?.constraints.forEach {
            if $0.firstItem === self || $0.secondItem === self {
                sourceViewСonstraints.append($0)
            }
        }
        view.removeConstraints(sourceViewСonstraints)
        translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        view.translatesAutoresizingMaskIntoConstraints = true
        
        if view.transform.a == 1, view.transform.d == 1 {
            placeholderView.frame.origin = view.frame.origin
        }
    }
    
    /// Когда контекстное меню закрывается снова меняем местами контент и плейсхолдер
    ///
    /// 1. Устанавливаем сохраненние свойство translatesAutoresizingMaskIntoConstraints
    /// 2. Добавляем контент на место
    /// 3. Копируем констрейны обратно с плейсхолдера на контент
    /// 4. Удаляем плейсхолдер
    func returnViewBack(view: UIView) {
        guard let placeholderView = placeholderView else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        
        placeholderView.superview?.addSubview(view)

        view.copyConstraints(from: placeholderView)
        view.frame = placeholderView.frame
        
        placeholderView.removeFromSuperview()
        self.placeholderView = nil
        self.position = nil
    }
}
