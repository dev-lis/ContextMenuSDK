//
//  FeedbackGenerator.swift
//  ContextMenu
//
//  Created by Aleksandr Lis on 07.08.2023.
//

import UIKit

enum HapticFeedbackType {
    case selectionChanged
    case impact(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle)
}

enum FeedbackGenerator {

    static func generateFeedback(type: HapticFeedbackType, withPrepare: Bool = true) {
        switch type {
        case .selectionChanged:
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            if withPrepare {
                selectionFeedbackGenerator.prepare()
            }
            selectionFeedbackGenerator.selectionChanged()

        case let .impact(feedbackStyle):
            let feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            if withPrepare {
                feedbackGenerator.prepare()
            }
            feedbackGenerator.impactOccurred()
        }
    }
}
