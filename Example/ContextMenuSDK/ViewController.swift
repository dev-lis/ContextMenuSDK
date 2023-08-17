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
        blueView.addContextMenu(
            for: .tap,
            with: actionSections,
            to: .bottomRight,
            withBlur: false
        )
    }
    
    private func setupSettings() {
        ContextMenuSettings.shared.animations.showAnimation = { blur, content, menu, completion in
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    content.transform = .identity
                    menu.transform = .identity
                    blur?.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            }) { _ in
                completion()
            }
        }
        ContextMenuSettings.shared.animations.hideAnimation = { blur, _, menu, completion in
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

