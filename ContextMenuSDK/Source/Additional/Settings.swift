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
    
    public var menu: Menu = .init()
    public var menuAction: MenuAction = .init()
    public var animations: Animations = .init()
    
    public class Menu {
        public var width: CGFloat = 250.0
        public var insetOfLeftAndRight: CGFloat = 16.0
        public var insetOfContent: CGFloat = 8.0
        public var cornerRadius: CGFloat = 12.0
        public var footerHeight: CGFloat = 12.0
        public var separatorColor: UIColor = .systemGray4
    }
    
    public class MenuAction {
        public var defaultBackgroundColor: UIColor = .systemGray6
        public var selectedBackgroundColor: UIColor = .systemGray5
        public var insetOfTopAndBottom: CGFloat = 8.0
        public var insetOfLeftAndRight: CGFloat = 16.0
        public var imageSize: CGFloat = 20.0
        public var font: UIFont? = .systemFont(ofSize: 17)
        public var defaultTextColor: UIColor? = .black
        public var negativeTextColor: UIColor? = .systemRed
        public var defaultImageColor: UIColor? = .black
        public var negativeImageColor: UIColor? = .systemRed
    }
    
    public class Animations {
        public var scaleFactor: CGFloat = 0.25
        public var scaleDuration: CGFloat = 0.2
        public var showTransitionDuration: TimeInterval = 0.25
        public var hideTransitionDuration: TimeInterval = 0.25
        public var showAnimation: ((UIVisualEffectView?, UIView, UIView, @escaping () -> Void) -> Void)? = nil
        public var hideAnimation: ((UIVisualEffectView?, UIView, UIView, @escaping () -> Void) -> Void)? = nil
        
        public init() {}
    }
}
