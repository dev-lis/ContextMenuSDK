//
//  TriggerViewHandler.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 22.01.2024.
//

import Foundation

/// Если триггером для отображения контекстного меню, является другая вью,
/// то нужно нужно сохранить эту пару иметь тоступ и к TriggerView и к ContentView
final class TriggerViewHandler {
    
    static let shared = TriggerViewHandler()
    
    private var views: [Weak<UIView>: Weak<UIView>] = [:]
    
    func setView(_ view: UIView, for trigger: UIView) {
        views[Weak(trigger)] = Weak(view)
    }
    
    func getContentView(for trigger: UIView) -> UIView {
        guard
            let view = views.first(where: { $0.key.object == trigger })?.value
        else {
            return trigger
        }
        return view.object ?? UIView()
    }
    
    func getTriggerView(for source: UIView) -> UIView {
        guard
            let view = views.first(where: { $0.value.object == source })?.key
        else {
            return source
        }
        return view.object ?? UIView()
    }
}
