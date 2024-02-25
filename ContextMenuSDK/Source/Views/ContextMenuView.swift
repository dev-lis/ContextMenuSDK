//
//  ContextMenuView.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 07.08.2023.
//

import UIKit

final class ContextMenuView: UIView {
    
    private var menuSettings = Settings.shared.menu
    private var menuActionSettings = Settings.shared.menuAction
    private var animationsSettings = Settings.shared.animations
    private let accessibilityIdentifiers = Settings.shared.accessibilityIdentifiers
    
    private var views = [ContextMenuActionView]()
    
    private var currentView: UIView?
    private var defaultStateColor: UIColor?
    
    private let origin: CGPoint
    private let actionSections: [ContextMenuSection]
    private let menuWidth: CGFloat
    private let completion: () -> Void
    
    init(origin: CGPoint,
         actionSections: [ContextMenuSection],
         menuWidth: CGFloat,
         completion: @escaping () -> Void) {
        self.origin = origin
        self.actionSections = actionSections
        self.menuWidth = menuWidth
        self.completion = completion
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        accessibilityIdentifier = accessibilityIdentifiers.menuView
        
        layer.cornerRadius = menuSettings.cornerRadius
        // добавляем тап без экшена, чтобы по тапу на меню (сепараторы) контекстное меню не закрывалось
        addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil))
        
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor {
            $0.userInterfaceStyle == .light
                ? .white
                : .black
        }
        containerView.layer.cornerRadius = menuSettings.cornerRadius
        addSubview(containerView)
        
        views.removeAll()
        
        var height: CGFloat = 0.0
        
        for section in actionSections {
            if let header = section.header {
                let sectionSeparator = UIView()
                sectionSeparator.frame = CGRect(
                    x: 0,
                    y: height,
                    width: menuWidth,
                    height: header.height ?? menuSettings.footerHeight
                )
                sectionSeparator.backgroundColor = header.color ?? menuSettings.separatorColor
                containerView.addSubview(sectionSeparator)
                
                height = sectionSeparator.frame.maxY
            }
            
            for (index, action) in section.actions.enumerated() {
                let view = ContextMenuActionView(
                    action: action,
                    menuWidth: menuWidth
                ) { [weak self] in
                    self?.completion()
                }
                view.frame.origin = CGPoint(x: 0, y: height)
                containerView.addSubview(view)
                
                views.append(view)
                
                guard index < section.actions.count - 1 else {
                    height = view.frame.maxY
                    break
                }
                
                let line = UIView()
                line.frame = CGRect(
                    x: 0,
                    y: height + view.frame.height,
                    width: menuWidth,
                    height: 0.3
                )
                line.backgroundColor = menuSettings.separatorColor
                containerView.addSubview(line)
                
                height = line.frame.maxY
            }
        }
        containerView.frame = CGRect(
            x: 0,
            y: 0,
            width: menuWidth,
            height: height
        )
        frame.origin = CGPoint(
            x: origin.x,
            y: origin.y
        )
        frame.size = containerView.frame.size
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)

        views.forEach {
            if $0.frame.contains(point) {
                currentView = $0
                defaultStateColor = $0.backgroundColor
            }
        }
        currentView?.backgroundColor = menuActionSettings.selectedBackgroundColor
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)

        guard bounds.contains(point) else {
            resetCurrentView()
            return
        }

        views.forEach {
            if $0.frame.contains(point), $0 != currentView {
                currentView?.backgroundColor = defaultStateColor
                currentView = $0

                FeedbackGenerator.generateFeedback(type: .selectionChanged)
            }
        }
        currentView?.backgroundColor = menuActionSettings.selectedBackgroundColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentView?.backgroundColor = defaultStateColor
        currentView = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentView?.backgroundColor = defaultStateColor
        currentView = nil
    }
    
    private func resetCurrentView() {
        guard currentView != nil else { return }
        currentView?.backgroundColor = defaultStateColor
        currentView = nil

        FeedbackGenerator.generateFeedback(type: .impact(feedbackStyle: .light))
    }
}
