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
    private var keyboardFrame: CGRect = .zero
    
    private var snapshotView: UIView?
    private var selectedView: UIView?

    private var store = Set<AnyCancellable>()
    
    static let shared = KeyboardHandler()

    private init() {
        subscribe()
    }
    
    /// Начиная с iOS 16 окно с клавиатурой размещается в _UIKeyboardWindowScene и больше не краниться в массиве окно приложения. Получить доступ к этому окну больше возможности нет, чтобы можно было что то запрезентить над клавиатурой. Поэтому подкладываем скриншот клавиатуры.
    ///
    /// 1. Если клавиатура на экране, сохраняем TextField или TextView которая его вызвала
    /// 2. Отключаем все анимации
    /// 3. Создаем UIImageView с размерами клавиатуры
    /// 4. Делаем снепшол всего экрана
    /// 5. Вставляем сделанные снепшот в UIImageView, центруем его по нижнему краю ит обрезаем все лишнее, так чтобы бидно было только клавиатуру
    /// 6. Вызываем скрытие клавиатуры. Т.к. анимации отключены произойдет это мгоновенно, а вот под клавиатурой уже лежит снепшот
    /// 7. Через NotificationCenter отправляем событие показа клавиатуры, чтобы все подписчики могли его поймать и обработать лэйаут
    /// 8. Включаем анимации
    func addSnapshotIfNeed() {
        guard isShown else {
            return
        }
        
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        
        if let textField = window?.selectedTextField {
            selectedView = textField
        } else if let textView = window?.selectedTextView {
            selectedView = textView
        }
        
        UIView.setAnimationsEnabled(false)
        
        let snapshotFrame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - KeyboardHandler.shared.keyboardFrame.height,
            width: KeyboardHandler.shared.keyboardFrame.width,
            height: KeyboardHandler.shared.keyboardFrame.height
        )
        let imageView = UIImageView(frame: snapshotFrame)
        imageView.contentMode = .bottom
        imageView.clipsToBounds = true
        
        imageView.image = takeScreenshot()
        
        window?.addSubview(imageView)
        
        snapshotView = imageView
        
        window?.endEditing(true)
        
        let value = NSValue(cgRect: KeyboardHandler.shared.keyboardFrame)
        let userInfo = [UIResponder.keyboardFrameBeginUserInfoKey: value]
        
        NotificationCenter.default.post(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: userInfo
        )
        
        NotificationCenter.default.post(
            name: UIResponder.keyboardDidShowNotification,
            object: nil,
            userInfo: userInfo
        )
        
        NotificationCenter.default.post(
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            userInfo: userInfo
        )
        
        UIView.setAnimationsEnabled(true)
    }
    
    /// Удаляем снепшот с клавиатурой
    ///
    /// 1. Отключаем все анимации
    /// 2. Если клавиатура была на экране перед открытием контекстного меню,
    ///   то вызываем клавиатуру у сохраненного TextField или TextView
    /// 3. С небольшой задержкой (чтобы анимация клавиатуры не была заметна) удаляем снепшот клавиатуры с экрана
    /// 4. Включаем все анимации
    func removeSnapshotIfNeed() {
        UIView.setAnimationsEnabled(false)
        
        selectedView?.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.snapshotView?.removeFromSuperview()
            self.snapshotView = nil
            
            UIView.setAnimationsEnabled(true)
        }
    }
}

private extension KeyboardHandler {
    func subscribe() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidShowNotification)
            .sink { [weak self] notification in
                guard let userInfo = notification.userInfo else { return }
                if self?.keyboardFrame == .zero {
                    self?.keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                }
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
    
    func takeScreenshot() -> UIImage {
        let snaposhotView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let renderer = UIGraphicsImageRenderer(size: snaposhotView.bounds.size)
        return renderer.image { context in
                snaposhotView.drawHierarchy(in: snaposhotView.bounds, afterScreenUpdates: true)
        }
    }
}
