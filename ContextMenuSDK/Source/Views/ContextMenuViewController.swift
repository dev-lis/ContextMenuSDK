//
//  ContextMenuViewController.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 01.05.2023.
//

import UIKit

final class ContextMenuViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset.bottom = menuSettings.insetOfContent
        return scrollView
    }()
    
    private(set) var backgroundContent: BackgroundContent = .none
    
    private var statusBarHidden = true {
        didSet {
            if oldValue != statusBarHidden {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    private let menuSettings = Settings.shared.menu
    private let accessibilityIdentifiers = Settings.shared.accessibilityIdentifiers

    override var prefersStatusBarHidden: Bool {
        guard withBlur else {
            return false
        }
        return statusBarHidden
    }
    
    private let withBlur: Bool
    
    init(withBlur: Bool) {
        self.withBlur = withBlur
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarHidden = false
    }
    
    func setContent(_ contentView: ContextMenuContentView,
                    with backgroundContent: BackgroundContent,
                    for position: MenuPosition) {
        func addBackgroundView(_ backgroundView: UIView) {
            statusBarHidden = true
            view.insertSubview(backgroundView, at: 0)
        }
        
        self.backgroundContent = backgroundContent
        
        switch backgroundContent {
        case let .blur(blur):
            blur.accessibilityIdentifier = accessibilityIdentifiers.blurView
            addBackgroundView(blur)
        case let .view(view):
            view.accessibilityIdentifier = accessibilityIdentifiers.mainView
            addBackgroundView(view)
        case .none:
            view.accessibilityIdentifier = accessibilityIdentifiers.mainView
            break
        }
        
        scrollView.contentSize = CGSize(
            width: contentView.bounds.width,
            height: contentView.bounds.height + menuSettings.sideInset
        )
        if contentView.frame.origin.y < Screen.SafeArea.top {
            let y = position.bottom
            ? Screen.SafeArea.top + menuSettings.sideInset
            : menuSettings.sideInset
            contentView.frame.origin = CGPoint(
                x: contentView.frame.origin.x,
                y: y
            )
        }
        
        scrollView.addSubview(contentView)
        let offset = CGPoint(
            x: 0,
            y: -contentView.y + menuSettings.sideInset
        )
        scrollView.setContentOffset(offset, animated: false)
    }
    
    @objc private func didTap() {
        dismiss(animated: true)
    }
}
