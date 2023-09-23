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
//        blueView.addContextMenu(
//            for: .longPress,
//            with: actionSections,
//            to: .bottomRight,
//            withBlur: true
//        )
        
        let config = ContextMenuViewConfig(
            actionSections: actionSections,
            trigger: .longPress,
            position: .topCenter
        )
        ContextMenu.add(
            to: blueView,
            with: config
        )
        
        if let image = UIImage(systemName: "trash"), let image2 = UIImage(systemName: "folder.badge.plus") {
//            let item = UIBarButtonItem(
//                image: image,
//                for: .tap,
//                with: actionSections,
//                to: .bottomCenter,
//                withBlur: false
//            )
//            let item2 = UIBarButtonItem(
//                image: image2,
//                for: .longPress,
//                with: actionSections,
//                to: .bottomCenter,
//                withBlur: true
//            )
//            navigationItem.rightBarButtonItems = [item, item2]
//            
//            let navBarItemConfig = ContextMenuNavBarItemConfig(
//                actionSections: actionSections,
//                trigger: .tap,
//                withBlur: false
//            )
//            ContextMenu.add(
//                to: item,
//                with: navBarItemConfig
//            )
//            let navBarItemConfig2 = ContextMenuNavBarItemConfig(
//                actionSections: actionSections,
//                trigger: .longPress,
//                withBlur: true
//            )
//            ContextMenu.add(
//                to: item2,
//                with: navBarItemConfig2
//            )
        }
        
//        let item = UIBarButtonItem(
//            title: "add",
//            for: .tap,
//            with: actionSections,
//            to: .bottomCenter,
//            withBlur: false
//        )
//        navigationItem.leftBarButtonItem = item
        
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
        
    }
    
    private func setupSettings() {
        ContextMenu.settings.animations.showAnimation = { blur, content, menu, completion in
            UIView.animate(
                withDuration: 2.5,
                animations: {
                    content.transform = .identity
                    menu.transform = .identity
                    blur?.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            }) { _ in
                completion()
            }
        }
        ContextMenu.settings.animations.hideAnimation = { blur, _, menu, completion in
            UIView.animate(
                withDuration: 3,
                animations: {
                    menu.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    blur?.effect = UIBlurEffect(style: .light)
            }) { _ in
                completion()
            }
        }
    }
}

