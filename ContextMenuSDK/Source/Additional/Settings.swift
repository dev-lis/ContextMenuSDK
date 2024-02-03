//
//  Settings.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 06.08.2023.
//

import UIKit

public class Settings {
    
    static let shared = Settings()
    
    private init() {}
    
    public var contant: Contant = .init()
    public var menu: Menu = .init()
    public var menuAction: MenuAction = .init()
    public var animations: Animations = .init()
    public var accessibilityIdentifiers: AccessibilityIdentifiers = .init()
    
    public class Contant {
        /// Тень
        public var shadow: Shadow = .init()
    }
    
    public class Menu {
        /// Ширина
        public var width: MenuWidth = .dynamic(inset: 48)
        /// Отступы от правого и левого краев
        public var sideInset: CGFloat = 8.0
        /// Отступ меню от контента
        public var insetOfContent: CGFloat = 8.0
        /// Радиус углов
        public var cornerRadius: CGFloat = 12.0
        /// Высота футеров в секциях
        public var footerHeight: CGFloat = 12.0
        /// Цвет фона меню
        public var backgroundColor: UIColor = .clear
        /// Цвет сепараторов между ячейками и футера
        public var separatorColor: UIColor = .systemGray4
        /// Тень
        public var shadow: Shadow = .init()
    }
    
    public class MenuAction {
        /// Цвет обычных ячеек в меню
        public var defaultBackgroundColor: UIColor = .systemGray6
        /// Цвет выделенных ячеек в меню
        public var selectedBackgroundColor: UIColor = .systemGray5
        /// Отстыпы внутри ячейки от верхнего и нижнего краев
        public var insetOfTopAndBottom: CGFloat = 8.0
        /// Отстыпы внутри ячейки от правого и левого краев
        public var sideInset: CGFloat = 16.0
        /// Размер иконки
        public var imageSize: CGFloat = 20.0
        /// Шрифт текста
        public var font: UIFont? = .systemFont(ofSize: 17)
        /// Цвет обычного текста
        public var defaultTextColor: UIColor? = .black
        /// Альтернативный цвет текста
        public var negativeTextColor: UIColor? = .systemRed
        /// Цвет обычного иконки
        public var defaultImageColor: UIColor? = .black
        /// Альтернативный цвет иконки
        public var negativeImageColor: UIColor? = .systemRed
    }
    
    public class Animations {
        /// Стиль блюра  (используется с BackgroudType == .blur)
        public var blurStyle: UIBlurEffect.Style = .systemUltraThinMaterialDark
        /// Цвет фона (используется с BackgroudType == .color)
        public var backgroundColor: UIColor = .black.withAlphaComponent(0.2)
        /// Абсолютная величина на которую сжимается каждая сторона. Если это значение превышает scaleValue в относительном занчении, то используется scaleFactor
        public var scaleValue: CGFloat = 6.0
        /// Относительная величина на которую сжимается каждая сторона
        public var scaleFactor: CGFloat = 0.2
        /// Продолжительность скеил аниации (когда при нажатии, вью проваливается)
        public var scaleDuration: CGFloat = 0.2
        /// Продолжительность анимации открытия
        public var showTransitionDuration: TimeInterval = 0.25
        /// Продолжительность анимации закрытия
        public var hideTransitionDuration: TimeInterval = 0.25
        /// Колбек, который позвонялет полностью переопределить поведение аниации открытия. Все анимации связанные с перемещение объектов, при необходимости, обрабатываются под капотом. Здесь можно обработать только только простые вещи, например анимацию "вплытия" после скейла или закругления углов.
        /// - Parameters:
        ///     - BackgroundContent: энум через который можно молучить бекграунд
        ///     - UIView: непосредственно сама вью, на которое было нажание
        ///     - UIView: меню
        ///     - () -> Void: всегда необходимо вызывать после окончания анимации. В нем обрабатывается завершение перехода
        public var showAnimation: ((BackgroundContent, UIView, UIView, @escaping () -> Void) -> Void)? = nil
        /// Колбек, который позвонялет полностью переопределить поведение аниации закрытия. Если переопределяется анимация отображения,то здесь стоит все вернуть как было.
        /// - Parameters:
        ///     - BackgroundContent: энум через который можно молучить бекграунд
        ///     - UIView: непосредственно сама вью, на которое было нажание
        ///     - UIView: меню
        ///     - () -> Void: всегда необходимо вызывать после окончания анимации. В нем обрабатывается завершение перехода
        public var hideAnimation: ((BackgroundContent, UIView, UIView, @escaping () -> Void) -> Void)? = nil
    }
    
    public struct Shadow {
        let shadowColor: UIColor
        let shadowOpacity: Float
        let shadowOffset: CGSize
        let shadowRadius: CGFloat
        
        public init(shadowColor: UIColor = .black.withAlphaComponent(0.15),
                    shadowOpacity: Float = 1.0,
                    shadowOffset: CGSize = .zero,
                    shadowRadius: CGFloat = 10.0) {
            self.shadowColor = shadowColor
            self.shadowOpacity = shadowOpacity
            self.shadowOffset = shadowOffset
            self.shadowRadius = shadowRadius
        }
    }
    
    public class AccessibilityIdentifiers {
        /// Идентификатор основное вью
        public var mainView: String? = nil
        /// Идентификатор блюра
        public var blurView: String? = nil
        /// Идентификатор меню
        public var menuView: String? = nil
    }
}

public enum MenuWidth {
    case absolute(width: CGFloat)
    case dynamic(inset: CGFloat)
}
