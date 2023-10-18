//
//  ViewController.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 08/08/2023.
//  Copyright (c) 2023 Aleksandr Lis. All rights reserved.
//

import UIKit
import ContextMenuSDK

class ViewController: UIViewController {
    
    private lazy var squareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupView()
//        setupSettings()
    }
    
    private func setupNavBar() {
        let mute = ContextMenuAction(
            text: "Mute",
            image: UIImage(systemName: "volume.slash.fill")
        ) {
            print("Mute")
        }
        let share = ContextMenuAction(
            text: "Share",
            image: UIImage(systemName: "square.and.arrow.up")
        ) {
            print("Share")
        }
        let actionSections = [ContextMenuSection(actions: [mute, share])]
        
        let image = UIImageView(image: UIImage(named: "more"))
        let item = UIBarButtonItem(customView: image)
        let config = ContextMenuNavBarItemConfig(actionSections: actionSections)
        ContextMenu.add(
            to: item,
            with: config
        )
        navigationItem.rightBarButtonItem = item
    }
    
    private func setupView() {
        view.addSubview(squareView)
        
        NSLayoutConstraint.activate([
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            squareView.widthAnchor.constraint(equalToConstant: 150),
            squareView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let play = ContextMenuAction(
            text: "Play",
            image: UIImage(systemName: "arrowtriangle.right.circle.fill")
        ) {
            print("Play")
        }
        let download = ContextMenuAction(
            text: "Download",
            image: UIImage(systemName: "tray.and.arrow.down.fill")
        ) {
            print("Download")
        }
        let delete = ContextMenuAction(
                text: "Delete",
            type: .negative,
            image: UIImage(systemName: "trash")
        ) {
            print("Delete")
        }
        let footer = ContextMenuSection.Footer()
        let actionSections = [
            ContextMenuSection(actions: [play, download], footer: footer),
            ContextMenuSection(actions: [delete])
        ]
        
        let config = ContextMenuViewConfig(
            actionSections: actionSections,
            trigger: .longPress,
            position: .topRight
        )
        ContextMenu.add(
            to: squareView,
            with: config
        )
    }
    
    private func setupSettings() {
        ContextMenu.settings.animations.showAnimation = { backgroundContent, content, menu, completion in
            UIView.animate(
                withDuration: 2.5,
                animations: {
                    content.transform = .identity
                    menu.transform = .identity
                    switch backgroundContent {
                    case let .blur(blur):
                        blur.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
                    case let .view(view):
                        view.backgroundColor = .red.withAlphaComponent(0.2)
                    case .none:
                        break
                    }
            }) { _ in
                completion()
            }
        }
        ContextMenu.settings.animations.hideAnimation = { backgroundContent, _, menu, completion in
            UIView.animate(
                withDuration: 3,
                animations: {
                    menu.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    switch backgroundContent {
                    case let .blur(blur):
                        blur.effect = UIBlurEffect(style: .light)
                    case let .view(view):
                        view.backgroundColor = .red.withAlphaComponent(0.2)
                    case .none:
                        break
                    }
            }) { _ in
                completion()
            }
        }
    }
}

