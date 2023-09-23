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
    
    private var views = [ContextMenuActionView]()
    
    private var currentView: UIView?
    private var defaultStateColor: UIColor?
    
    private let origin: CGPoint
    private let actionSections: [ContextMenuSection]
    private let completion: () -> Void
    
    init(origin: CGPoint,
         actionSections: [ContextMenuSection],
         completion: @escaping () -> Void) {
        self.origin = origin
        self.actionSections = actionSections
        self.completion = completion
        super.init(frame: .zero)
        setup()
        backgroundColor = .red
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = menuSettings.cornerRadius
        clipsToBounds = true
        // добавляем тап без экшена, чтобы по тапу на меню (сепараторы) контекстное меню не закрывалось
        addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil))
        
        views.removeAll()
        
        var height: CGFloat = 0.0
        
        for section in actionSections {
            for (index, action) in section.actions.enumerated() {
                let view = ContextMenuActionView(action: action) { [weak self] in
                    self?.completion()
                }
                view.frame.origin = CGPoint(x: 0, y: height)
                addSubview(view)
                
                views.append(view)
                
                guard index < section.actions.count - 1 else {
                    height = view.frame.maxY
                    break
                }
                
                let line = UIView()
                line.frame = CGRect(
                    x: 0,
                    y: height + view.frame.height,
                    width: menuSettings.width,
                    height: 0.3
                )
                line.backgroundColor = menuSettings.separatorColor
                addSubview(line)
                
                height = line.frame.maxY
            }
            
            guard let footer = section.footer else {
                continue
            }
            let sectionSeparator = UIView()
            sectionSeparator.frame = CGRect(
                x: 0,
                y: height,
                width: menuSettings.width,
                height: footer.height ?? menuSettings.footerHeight
            )
            sectionSeparator.backgroundColor = footer.color ?? menuSettings.separatorColor
            addSubview(sectionSeparator)
            
            height = sectionSeparator.frame.maxY
        }
        frame = CGRect(
            x: origin.x,
            y: origin.y,
            width: menuSettings.width,
            height: height
        )
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
