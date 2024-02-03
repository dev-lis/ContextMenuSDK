//
//  String+Extensions.swift
//  ContextMenuSDK
//
//  Created by Aleksandr Lis on 03.02.2024.
//

import Foundation

extension String {
    func getWidth(with font: UIFont?) -> CGFloat {
        guard let font else {
            return .zero
        }
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes).width
    }
}
