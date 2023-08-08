//
//  UIView+CopyConstraints.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 02.05.2023.
//

import UIKit

extension UIView {
    
    func copyConstraints(from sourceView: UIView) {
        for constraint in sourceView.constraints {
            addCopyConstraint(constraint, from: sourceView)
        }
        
        for constraint in sourceView.superview?.constraints ?? [] {
            addCopyConstraint(constraint, from: sourceView)
        }
    }
    
    private func addCopyConstraint(_ constraint: NSLayoutConstraint,
                                   from sourceView: UIView) {
        guard let sourceViewSuperview = sourceView.superview else {
            return
        }
        
        if constraint.firstItem as? UIView == sourceView {
            sourceViewSuperview.addConstraint(
                NSLayoutConstraint(
                    item: self,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: constraint.secondItem,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant
                )
            )
        } else if constraint.secondItem as? UIView == sourceView {
            sourceViewSuperview.addConstraint(
                NSLayoutConstraint(
                    item: constraint.firstItem as Any,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: self,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant
                )
            )
        }
    }
}
