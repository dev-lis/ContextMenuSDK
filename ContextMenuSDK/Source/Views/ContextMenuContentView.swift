//
//  ContextMenuContentView.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 03.05.2023.
//

import UIKit

final class ContextMenuContentView: UIView {
    
    private var menuSettings = ContextMenuSettings.shared.menu
    private var animationsSettings = ContextMenuSettings.shared.animations
    
    private var startContentY: CGFloat = .zero
    
    let content: UIView
    private(set) var menuView: UIView!
    
    private let actionSections: [ContextMenuSection]
    private let position: MenuPosition
    private let completion: () -> Void
    
    init(content: UIView,
         actionSections: [ContextMenuSection],
         position: MenuPosition,
         completion: @escaping () -> Void) {
        self.content = content
        self.actionSections = actionSections
        self.position = position
        self.completion = completion
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveIfNeed() {
        startContentY = frame.origin.y
        
        let windowHeight = window?.frame.height ?? .zero
        
        if frame.origin.y > Screen.SafeArea.top, frame.maxY > windowHeight - Screen.SafeArea.bottom {
            let diff = frame.maxY - windowHeight
            let y = frame.origin.y - diff - Screen.SafeArea.bottom - menuSettings.indentOfContent
            animateOriginY(to: y)
        } else if frame.origin.y < Screen.SafeArea.top {
            animateOriginY(to: Screen.SafeArea.top + menuSettings.indentOfContent)
        }
    }
    
    func moveToStartPositionIfNeed() {
        animateOriginY(to: startContentY)
    }
    
    func show() {
        content.transform = .identity
        menuView.transform = .identity
    }
    
//    func show() {
//        startContentY = frame.origin.y
//
//        let animationBlock = {
//            self.content.transform = .identity
//            self.menuView.transform = .identity
//        }
//
//        if let animation = ContextMenuSettings.shared.animations.showMenuAnimation {
//            animation((animationBlock, nil))
//        } else {
//            UIView.animate(
//                withDuration: animationsSettings.showTransitionDuration,
//                delay: 0,
//                usingSpringWithDamping: 0.75,
//                initialSpringVelocity: 5,
//                options: .curveEaseInOut)
//            {
//                animationBlock()
//            }
//        }
//
//        let windowHeight = window?.frame.height ?? .zero
//
//        if frame.origin.y > Screen.SafeArea.top, frame.maxY > windowHeight - Screen.SafeArea.bottom {
//            let diff = frame.maxY - windowHeight
//            let y = frame.origin.y - diff - Screen.SafeArea.bottom - menuSettings.indentOfContent
//            animateOriginY(to: y)
//        } else if frame.origin.y < Screen.SafeArea.top {
//            animateOriginY(to: Screen.SafeArea.top + menuSettings.indentOfContent)
//        }
//    }
    
    func hide() {
        menuView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }
}

private extension ContextMenuContentView {
    func setup() {
        switch position {
        case .topLeft:
            setupTopLeftPosition()
        case .topCenter:
            setupTopCenterPosition()
        case .topRight:
            setupTopRightMenu()
        case .bottomLeft:
            setupBottomLeftMenu()
        case .bottomCenter:
            setupBottomCenterMenu()
        case .bottomRight:
            setupBottomRightMenu()
        }
    }
    
    func contentValues() -> (contentOriginX: CGFloat, contentOriginY: CGFloat, contentWidthInset: CGFloat, contentHeightInset: CGFloat) {
        let contentWidthInset = content.bounds.width - content.frame.width
        let contentHeightInset = content.bounds.height - content.frame.height
        let contentOriginX = contentWidthInset / 2
        let contentOriginY = contentHeightInset / 2
        return (contentOriginX: contentOriginX,
                contentOriginY: contentOriginY,
                contentWidthInset: contentWidthInset,
                contentHeightInset: contentHeightInset)
    }
    
    func animateOriginY(to y: CGFloat) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.frame = CGRect(
                x: self.frame.origin.x,
                y: y,
                width: self.frame.width,
                height: self.frame.height
            )
        }
    }
}

// MARK: - Top positions
        
private extension ContextMenuContentView {
    func setupTopLeftPosition() {
        let tuple = contentValues()
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        let contentY = contentFrameOnWindow.origin.y + contentHeightInset / 2
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX: CGFloat
        let contentX: CGFloat
        
        if contentFrameOnWindow.origin.x + menuSettings.width > UIScreen.main.bounds.width - menuSettings.indentOfContent {
            /// Если правый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от правог края
            /// Вплоть до расположения эквивалентного .topLeft
            /// --------------------------------
            /// ----------------
            /// |  1. Action                  |               |
            /// ----------------
            /// |  2. Action                  |  <--->  |
            /// ----------------
            /// |  3. Action                  |               |
            /// ----------------
            ///   ---------
            ///   |   content   |
            ///   ---------
            ///
            
            containerX = UIScreen.main.bounds.width - menuSettings.width - menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        } else {
            /// Меню располагается по левому краю контента
            /// --------------------------------
            /// ----------------
            /// |  1. Action                  |
            /// ----------------
            /// |  2. Action                  |
            /// ----------------
            /// |  3. Action                  |
            /// ----------------
            /// ---------
            /// |   content   |
            /// ---------
            ///

            containerX = contentFrameOnWindow.origin.x - contentWidthInset / 2
            contentX = contentWidthInset / 2
        }
        
        setupTopMenu(
            containerX: containerX,
            containerWidth: containerWidth,
            contentOnWindowY: contentOriginY,
            contentX: contentX,
            contentY: contentY,
            contentHeightInset: contentHeightInset,
            menuX: 0
        )
    }
    
    func setupTopCenterPosition() {
        let tuple = contentValues()
        let contentOriginX = tuple.contentOriginX
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        let contentY = contentFrameOnWindow.origin.y + contentHeightInset / 2
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX = contentFrameOnWindow.origin.x - menuSettings.width + contentFrameOnWindow.width + contentWidthInset / 2
        let contentX: CGFloat
        var menuX: CGFloat = 0
        
        if content.frame.width > menuSettings.width {
            /// Если контен шире чем меню, тогда ширина контейнера будет равна ширине контента
            /// --------------------------------
            ///     -----------------
            ///     |  1. Action                    |
            ///     -----------------
            ///     |  2. Action                    |
            ///     -----------------
            ///     |  3. Action                    |
            ///     -----------------
            /// -------------------------
            /// |                    content                      |
            /// -------------------------
            ///
            
            containerX = contentFrameOnWindow.origin.x - contentOriginX
            contentX = contentOriginX
            menuX = contentFrameOnWindow.width / 2 + contentWidthInset / 2 - menuSettings.width / 2
        } else if contentFrameOnWindow.midX - containerWidth / 2 < menuSettings.indentOfContent {
            /// Если левый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от левого края
            /// Вплоть до расположения эквивалентного .topLeft или .bottomLeft
            /// --------------------------------
            ///        -----------------
            /// |               |  1. Action                    |
            ///        -----------------
            /// |  <--->  |  2. Action                    |
            ///        -----------------
            /// |               |  3. Action                    |
            ///        -----------------
            ///          ---------
            ///          |   content   |
            ///          ---------
            ///
            
            containerX = menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        } else if contentFrameOnWindow.midX + containerWidth / 2 < UIScreen.main.bounds.width - menuSettings.indentOfContent {
            /// Если контен уже чем меню, тогда ширина контейнера будет равна ширине меню
            /// --------------------------------
            /// -----------------
            /// |  1. Action                    |
            /// -----------------
            /// |  2. Action                    |
            /// -----------------
            /// |  3. Action                    |
            /// -----------------
            ///     ---------
            ///     |   content   |
            ///     ---------
            ///
            
            contentX = containerWidth / 2 - contentFrameOnWindow.width / 2
            containerX = contentFrameOnWindow.origin.x + contentFrameOnWindow.width / 2 - containerWidth / 2
        } else {
            /// Если правый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от правого края
            /// Вплоть до расположения эквивалентного .topRight или .bottomRight
            /// --------------------------------
            /// -----------------
            /// |  1. Action                    |               |
            /// -----------------
            /// |  2. Action                    |  <--->  |
            /// -----------------
            /// |  3. Action                    |               |
            /// -----------------
            ///       ---------
            ///       |   content   |
            ///       ---------
            ///
            
            containerX = UIScreen.main.bounds.width - menuSettings.width - menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        }

        
        setupTopMenu(
            containerX: containerX,
            containerWidth: containerWidth,
            contentOnWindowY: contentOriginY,
            contentX: contentX,
            contentY: contentY,
            contentHeightInset: contentHeightInset,
            menuX: menuX
        )
    }
    
    func setupTopRightMenu() {
        let tuple = contentValues()
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        let contentY = contentFrameOnWindow.origin.y + contentHeightInset / 2
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX = contentFrameOnWindow.origin.x - menuSettings.width + contentFrameOnWindow.width + contentWidthInset / 2
        let contentX: CGFloat
        let menuX: CGFloat
        
        if content.frame.width + contentWidthInset > menuSettings.width {
            /// Если контен шире чем меню, тогда ширина контейнера будет равна ширине контента
            /// --------------------------------
            ///         -----------------
            ///         |  1. Action                    |
            ///         -----------------
            ///         |  2. Action                    |
            ///         -----------------
            ///         |  3. Action                    |
            ///         -----------------
            /// -------------------------
            /// |                    content                      |
            /// -------------------------
            ///
            
            containerX = contentFrameOnWindow.origin.x - contentWidthInset / 2
            menuX = content.frame.width + contentWidthInset - menuSettings.width
            contentX = contentWidthInset / 2
        } else {
            if containerX < menuSettings.indentOfContent {
                /// Если левый край меню, должен оказаться за пределами экрана
                /// В этом случае меню располагается на минимальном отступе от левого края
                /// Вплоть до расположения эквивалентного .topLeft или .bottomLeft
                /// --------------------------------
                ///        -----------------
                /// |               |  1. Action                    |
                ///        -----------------
                /// |  <--->  |  2. Action                    |
                ///        -----------------
                /// |               |  3. Action                    |
                ///        -----------------
                ///          ---------
                ///          |   content   |
                ///          ---------
                ///
                
                containerX = menuSettings.indentOfSide
                menuX = 0.0
                contentX = contentFrameOnWindow.origin.x - containerX - menuX
            } else {
                /// Меню располагается по правому краю контента
                /// --------------------------------
                /// -----------------
                /// |  1. Action                    |
                /// -----------------
                /// |  2. Action                    |
                /// -----------------
                /// |  3. Action                    |
                /// -----------------
                ///         ---------
                ///         |   content   |
                ///         ---------
                ///
                
                menuX = 0.0
                contentX = contentFrameOnWindow.origin.x - containerX - menuX
            }
        }
        
        setupTopMenu(
            containerX: containerX,
            containerWidth: containerWidth,
            contentOnWindowY: contentOriginY,
            contentX: contentX,
            contentY: contentY,
            contentHeightInset: contentHeightInset,
            menuX: menuX
        )
    }
    
    func setupTopMenu(containerX: CGFloat,
                      containerWidth: CGFloat,
                      contentOnWindowY: CGFloat,
                      contentX: CGFloat,
                      contentY: CGFloat,
                      contentHeightInset: CGFloat,
                      menuX: CGFloat) {
        let origin = CGPoint(
            x: menuX,
            y: content.frame.maxY + menuSettings.indentOfContent
        )
        menuView = ContextMenuView(
            origin: origin,
            actionSections: actionSections,
            completion: completion
        )
        
        switch position {
        case .topLeft:
            menuView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        case .topCenter:
            menuView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        case .topRight:
            menuView.layer.anchorPoint = CGPoint(x: 1, y: 1)
        default:
            break
        }
        
        menuView.frame.origin = CGPoint(
            x: menuX,
            y: 0
        )
        menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        addSubview(menuView)
        
        content.frame.origin = CGPoint(
            x: contentX,
            y: menuView.bounds.height + menuSettings.indentOfContent
        )
        
        addSubview(content)
        
        let height = menuView.bounds.height + menuSettings.indentOfContent + content.frame.height + contentHeightInset / 2
        let y = contentOnWindowY + content.bounds.height - height < 0
        ? contentY - menuView.bounds.height - menuSettings.indentOfContent - contentOnWindowY
        : contentOnWindowY - menuView.bounds.height - menuSettings.indentOfContent - contentHeightInset / 2
        
        frame = CGRect(
            x: containerX,
            y: y,
            width: containerWidth,
            height: height
        )
    }
}

// MARK: - Bottom positions
        
private extension ContextMenuContentView {
    func setupBottomLeftMenu() {
        let tuple = contentValues()
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX: CGFloat
        let contentX: CGFloat
        
        if contentFrameOnWindow.origin.x + menuSettings.width > UIScreen.main.bounds.width - menuSettings.indentOfContent {
            /// Если правый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от правого края
            /// Вплоть до расположения эквивалентного .topLeft или .bottomLeft
            /// --------------------------------
            ///   ---------
            ///   |   content   |
            ///   ---------
            /// -----------------
            /// |  1. Action                    |               |
            /// -----------------
            /// |  2. Action                    |  <--->  |
            /// -----------------
            /// |  3. Action                    |               |
            /// -----------------
            ///
            
            containerX = UIScreen.main.bounds.width - menuSettings.width - menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        } else {
            /// Меню располагается по левому краю контента
            /// --------------------------------
            /// ---------
            /// |   content   |
            /// ---------
            /// -----------------
            /// |  1. Action                    |
            /// -----------------
            /// |  2. Action                    |
            /// -----------------
            /// |  3. Action                    |
            /// -----------------
            ///
            
            containerX = contentFrameOnWindow.origin.x - contentWidthInset / 2
            contentX = contentWidthInset / 2
        }
        
        setupBottomMenu(
            containerX: containerX,
            containerY: contentFrameOnWindow.origin.y - contentOriginY,
            containerWidth: containerWidth,
            contentOnWindowY: contentFrameOnWindow.origin.y,
            contentX: contentX,
            contentY: contentOriginY,
            contentHeightInset: contentHeightInset,
            menuX: 0
        )
    }
    
    func setupBottomCenterMenu() {
        let tuple = contentValues()
        let contentOriginX = tuple.contentOriginX
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX = contentFrameOnWindow.origin.x - menuSettings.width + contentFrameOnWindow.width + contentWidthInset / 2
        let contentX: CGFloat
        var menuX: CGFloat = 0
        
        if content.frame.width > menuSettings.width {
            /// Если контен шире чем меню, тогда ширина контейнера будет равна ширине контента
            /// --------------------------------
            /// -------------------------
            /// |                    content                      |
            /// -------------------------
            ///     -----------------
            ///     |  1. Action                    |
            ///     -----------------
            ///     |  2. Action                    |
            ///     -----------------
            ///     |  3. Action                    |
            ///     -----------------
            ///
            
            containerX = contentFrameOnWindow.origin.x - contentOriginX
            contentX = contentOriginX
            menuX = contentFrameOnWindow.width / 2 + contentWidthInset / 2 - menuSettings.width / 2
        } else if contentFrameOnWindow.midX - containerWidth / 2 < menuSettings.indentOfContent {
            /// Если левый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от левого края
            /// Вплоть до расположения эквивалентного .topLeft или .bottomLeft
            /// --------------------------------
            ///          ---------
            ///          |   content   |
            ///          ---------
            ///        -----------------
            /// |               |  1. Action                    |
            ///        -----------------
            /// |  <--->  |  2. Action                    |
            ///        -----------------
            /// |               |  3. Action                    |
            ///        -----------------
            ///
            
            containerX = menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        } else if contentFrameOnWindow.midX + containerWidth / 2 < UIScreen.main.bounds.width - menuSettings.indentOfContent {
            /// Если контен уже чем меню, тогда ширина контейнера будет равна ширине меню
            /// --------------------------------
            ///     ---------
            ///     |   content   |
            ///     ---------
            /// -----------------
            /// |  1. Action                    |
            /// -----------------
            /// |  2. Action                    |
            /// -----------------
            /// |  3. Action                    |
            /// -----------------
            ///
            
            contentX = containerWidth / 2 - contentFrameOnWindow.width / 2
            containerX = contentFrameOnWindow.origin.x + contentFrameOnWindow.width / 2 - containerWidth / 2
        } else {
            /// Если правый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от правого края
            /// Вплоть до расположения эквивалентного .topRight или .bottomRight
            /// --------------------------------
            ///       ---------
            ///       |   content   |
            ///       ---------
            /// -----------------
            /// |  1. Action                    |               |
            /// -----------------
            /// |  2. Action                    |  <--->  |
            /// -----------------
            /// |  3. Action                    |               |
            /// -----------------
            ///
            
            containerX = UIScreen.main.bounds.width - menuSettings.width - menuSettings.indentOfSide
            contentX = contentFrameOnWindow.origin.x - containerX
        }
        
        setupBottomMenu(
            containerX: containerX,
            containerY: contentFrameOnWindow.origin.y - contentOriginY,
            containerWidth: containerWidth,
            contentOnWindowY: contentFrameOnWindow.origin.y,
            contentX: contentX,
            contentY: contentOriginY,
            contentHeightInset: contentHeightInset,
            menuX: menuX
        )
    }
    
    func setupBottomRightMenu() {
        let tuple = contentValues()
        let contentOriginY = tuple.contentOriginY
        let contentWidthInset = tuple.contentWidthInset
        let contentHeightInset = tuple.contentHeightInset
        let contentFrameOnWindow = content.frameOnWindow
        
        let containerWidth = max(content.frame.width + contentWidthInset, menuSettings.width)
        var containerX = contentFrameOnWindow.origin.x - menuSettings.width + contentFrameOnWindow.width + contentWidthInset / 2
        let contentX: CGFloat
        let menuX: CGFloat
        
        if content.frame.width + contentWidthInset > menuSettings.width {
            /// Если контен шире чем меню, тогда ширина контейнера будет равна ширине контента
            /// --------------------------------
            /// -------------------------
            /// |                    content                      |
            /// -------------------------
            ///         -----------------
            ///         |  1. Action                    |
            ///         -----------------
            ///         |  2. Action                    |
            ///         -----------------
            ///         |  3. Action                    |
            ///         -----------------
            ///
            
            containerX = contentFrameOnWindow.origin.x - contentWidthInset / 2
            menuX = content.frame.width + contentWidthInset - menuSettings.width
            contentX = contentWidthInset / 2
        } else if containerX < menuSettings.indentOfContent {
            /// Если левый край меню, должен оказаться за пределами экрана
            /// В этом случае меню располагается на минимальном отступе от левого края
            /// Вплоть до расположения эквивалентного .topLeft или .bottomLeft
            /// --------------------------------
            ///          ---------
            ///          |   content   |
            ///          ---------
            ///        -----------------
            /// |               |  1. Action                    |
            ///        -----------------
            /// |  <--->  |  2. Action                    |
            ///        -----------------
            /// |               |  3. Action                    |
            ///        -----------------
            ///
            
            containerX = menuSettings.indentOfSide
            menuX = 0
            contentX = contentFrameOnWindow.origin.x - containerX
        } else {
            /// Меню располагается по правому краю контента
            /// --------------------------------
            ///         ---------
            ///         |   content   |
            ///         ---------
            /// -----------------
            /// |  1. Action                    |
            /// -----------------
            /// |  2. Action                    |
            /// -----------------
            /// |  3. Action                    |
            /// -----------------
            ///
            
            contentX = menuSettings.width - contentFrameOnWindow.width - contentWidthInset / 2
            menuX = 0
        }
        
        setupBottomMenu(
            containerX: containerX,
            containerY: contentFrameOnWindow.origin.y - contentOriginY,
            containerWidth: containerWidth,
            contentOnWindowY: contentFrameOnWindow.origin.y,
            contentX: contentX,
            contentY: contentOriginY,
            contentHeightInset: contentHeightInset,
            menuX: menuX
        )
    }
    
    func setupBottomMenu(containerX: CGFloat,
                         containerY: CGFloat,
                         containerWidth: CGFloat,
                         contentOnWindowY: CGFloat,
                         contentX: CGFloat,
                         contentY: CGFloat,
                         contentHeightInset: CGFloat,
                         menuX: CGFloat) {
        content.frame.origin = CGPoint(x: contentX, y: contentY)
        addSubview(content)
        
        let origin = CGPoint(
            x: menuX,
            y: content.frame.maxY + menuSettings.indentOfContent
        )
        menuView = ContextMenuView(
            origin: origin,
            actionSections: actionSections,
            completion: completion
        )
        
        switch position {
        case .bottomLeft:
            menuView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        case .bottomCenter:
            menuView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        case .bottomRight:
            menuView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        default:
            break
        }
        menuView.frame.origin = CGPoint(
            x: menuX,
            y: menuView.frame.origin.y - menuView.frame.height * 0.5
        )
        menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        addSubview(menuView)
        
        frame = CGRect(
            x: containerX,
            y: containerY,
            width: containerWidth,
            height: content.frame.height + menuView.bounds.height + menuSettings.indentOfContent + contentHeightInset / 2
        )
    }
}
