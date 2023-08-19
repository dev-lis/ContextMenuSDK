//
//  UIView+Keyboard.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 09.05.2023.
//

import UIKit

extension UIView {
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
    
    var selectedTextView: UITextView? {
        return textViewsInView.filter { $0.isFirstResponder }.first
    }
    
    private var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
        })
    }
    
    private var textViewsInView: [UITextView] {
        return subviews
            .filter ({ !($0 is UITextView) })
            .reduce (( subviews.compactMap { $0 as? UITextView }), { summ, current in
                return summ + current.textViewsInView
        })
    }
}

extension UIView {
    var activeTextField: UITextField? {
        let totalTextFields = getTextFieldsInView(view: self)
        
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        
        return nil
        
    }
    
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        var totalTextFields = [UITextField]()
        
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        
        return totalTextFields
    }
    
}
