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
        
        Settings.shared.animations.showBlurAnimation = { block in
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    block.animation()
            }) { _ in
                block.completion?()
            }
        }
        Settings.shared.animations.hideBlurAnimation = { block in
            UIView.animate(
                withDuration: 5,
                animations: {
                    block.animation()
            }) { _ in
                block.completion?()
            }
        }
        Settings.shared.animations.showMenuAnimation = { block in
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    block.animation()
            }) { _ in
                block.completion?()
            }
        }
        Settings.shared.animations.hideMenuAnimation = { block in
            UIView.animate(
                withDuration: 5,
                animations: {
                    block.animation()
            }) { _ in
                block.completion?()
            }
        }
        
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
        blueView.addContextMenu(
            with: actionSections,
            to: .bottomCenter
        )
    }
}

