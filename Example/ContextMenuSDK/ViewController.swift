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
    
    @IBOutlet weak var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupSettings()
        
        let copy = ContextMenuAction(
            text: "Copy",
            image: UIImage(systemName: "doc.on.doc")
        ) {
            print("Copy")
        }
        let share = ContextMenuAction(
            text: "Share",
            image: UIImage(systemName: "square.and.arrow.up")
        ) {
            print("Share")
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
            ContextMenuSection(actions: [copy, share], footer: footer),
            ContextMenuSection(actions: [delete])
        ]
        
        let config = ContextMenuViewConfig(
            actionSections: actionSections,
            trigger: .longPress,
            position: .topCenter
        )
        ContextMenu.add(
            to: blueView,
            with: config
        )
        view.layer.shadowRadius
        tabBarItem = UITabBarItem(title: "first", image:  UIImage(systemName: "trash"), tag: 1)
        
        tabBarItem.badgeValue = "1"
        tabBarItem.tag = 2
        
        let tabBarConfig = ContextMenuTabBarItemConfig(
            actionSections: actionSections
        )
        ContextMenu.add(
            to: tabBarItem,
            with: tabBarConfig
        )
        
        let label1 = UILabel()
        label1.text = "Add"
        let item1 = UIBarButtonItem(customView: label1)
        let navBarConfig1 = ContextMenuNavBarItemConfig(
            actionSections: actionSections,
            trigger: .tap
        )
        ContextMenu.add(
            to: item1,
            with: navBarConfig1
        )

        let image2 = UIImageView(image: UIImage(systemName: "trash"))
        let item2 = UIBarButtonItem(customView: image2)
        let navBarConfig2 = ContextMenuNavBarItemConfig(
            actionSections: actionSections,
            trigger: .tap
        )
        ContextMenu.add(
            to: item2,
            with: navBarConfig2
        )
        navigationItem.leftBarButtonItems = [item1, item2]
        
        let label3 = UILabel()
        label3.text = "Add"
        let item3 = UIBarButtonItem(customView: label3)
        let navBarConfig3 = ContextMenuNavBarItemConfig(
            actionSections: actionSections,
            trigger: .longPress
        )
        ContextMenu.add(
            to: item3,
            with: navBarConfig3
        )

        let image4 = UIImageView(image: UIImage(systemName: "trash"))
        let item4 = UIBarButtonItem(customView: image4)
        let navBarConfig4 = ContextMenuNavBarItemConfig(
            actionSections: actionSections,
            trigger: .longPress
        )
        ContextMenu.add(
            to: item4,
            with: navBarConfig4
        )
        navigationItem.rightBarButtonItems = [item3, item4]
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

