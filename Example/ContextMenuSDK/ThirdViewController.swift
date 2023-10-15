//
//  ThirdViewController.swift
//  ContextMenuSDK_Example
//
//  Created by Aleksandr Lis on 16.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import ContextMenuSDK
import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let tabBarConfig = ContextMenuTabBarItemConfig(
            actionSections: actionSections
        )
        ContextMenu.add(
            to: tabBarItem,
            with: tabBarConfig
        )
    }
}
