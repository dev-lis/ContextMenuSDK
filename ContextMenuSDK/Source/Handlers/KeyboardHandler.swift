//
//  KeyboardHandler.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import Combine
import UIKit

class KeyboardHandler {

    private var isShown = false
    
    private var snapshotView: UIView?
    private var selectedView: UIView?

    private var store = Set<AnyCancellable>()
    
    static let shared = KeyboardHandler()

    private init() {
        subscribe()
    }
    
    /// Начиная с iOS 16 окно с клавиатурой размещается в _UIKeyboardWindowScene и больше не храниться в массиве окно приложения. Получить доступ к этому окну больше возможности нет, чтобы можно было что то запрезентить над клавиатурой. Поэтому подкладываем скриншот клавиатуры.
    /// Если клавиатура на экране, сохраняем TextField или TextView которая его вызвала
    func saveFirstResponderIfNeed() {
        guard isShown else {
            return
        }
        
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        
        if let textField = window?.selectedTextField {
            selectedView = textField
        } else if let textView = window?.selectedTextView {
            selectedView = textView
        }
    }
    
    /// Если клавиатура была на экране перед открытием контекстного меню,
    ///   то вызываем клавиатуру у сохраненного TextField или TextView
    func becomeFirstResponderIfNeed() {
        selectedView?.becomeFirstResponder()
    }
}

private extension KeyboardHandler {
    func subscribe() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidShowNotification)
            .sink { [weak self] notification in
                self?.isShown = true
            }
            .store(in: &store)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidHideNotification)
            .sink { [weak self] _ in
                self?.isShown = false
            }
            .store(in: &store)
    }
}
