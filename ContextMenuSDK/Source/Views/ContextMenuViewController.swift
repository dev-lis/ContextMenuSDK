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
        scrollView.contentInset.top = -Screen.SafeArea.top
        scrollView.contentInset.bottom = Screen.SafeArea.top + Screen.SafeArea.bottom
        return scrollView
    }()
    
    private(set) var blurEffectView: UIVisualEffectView?
    
    private var statusBarHidden = true {
        didSet {
            if oldValue != statusBarHidden {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

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
    
    func setContent(_ contentView: UIView, with blur: UIVisualEffectView?) {
        if let blur = blur {
            statusBarHidden = true
            view.insertSubview(blur, at: 0)
            blurEffectView = blur
        }
        
        scrollView.contentSize = contentView.frame.size
        
        if contentView.frame.origin.y < Screen.SafeArea.top {
            contentView.frame.origin = CGPoint(
                x: contentView.frame.origin.x,
                y: Screen.SafeArea.top
            )
        }
        
        scrollView.addSubview(contentView)
        
        if contentView.frame.maxY > contentView.window?.frame.height ?? .zero {
            let y = contentView.frame.size.height > view.window?.frame.height ?? 0
            ? 0
            : scrollView.contentSize.height - scrollView.bounds.height
            let offset = CGPoint(
                x: 0,
                y: y
            )
            scrollView.setContentOffset(offset, animated: false)
        } else {
            scrollView.contentInset.top = .zero
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
    
    @objc private func didTap() {
        dismiss(animated: true)
    }
}
