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
            trigger: .tap,
            withBlur: false
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
            trigger: .longPress,
            withBlur: false,
            menuWidth: 400
        )
        ContextMenu.add(
            to: item4,
            with: navBarConfig4
        )
        navigationItem.rightBarButtonItems = [item3, item4]
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

