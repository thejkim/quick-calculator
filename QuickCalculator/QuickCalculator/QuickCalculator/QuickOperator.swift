//
//  QuickOperator.swift
//  QuickCalculator
//
//  Created by Joeun Kim on 10/21/21.
//

import UIKit

enum QuickOperatorPosition {
    case left
    case right
    case top
    case bottom
}

enum QuickOperatorType : Int{
    case none = 100
    case plus = 101
    case minus = 102
    case multiply = 103
    case divide = 104
}

class QuickOperator {
    var superView:UIView?

    // Quick Operator Appearance
    var cornerRadius:CGFloat = 20.0
    var sizeRatioToAnchor:CGFloat = 0.8
    var spaceToAnchor:CGFloat = 12.0

    init(cornerRadius: CGFloat, sizeRatio: CGFloat, space: CGFloat) {
        self.cornerRadius = cornerRadius
        self.sizeRatioToAnchor = sizeRatio
        self.spaceToAnchor = space
    }

    // Add a Quick Operator on the super view on the super view
    func add(_ type: QuickOperatorType, at position: QuickOperatorPosition, for button: UIButton) {
        if let superView = superView {
            let btnFrame = button.frame
            JLog("Adding QO for Number Button at", CGRect: btnFrame)

            let opHeight = btnFrame.height*sizeRatioToAnchor
            let opWidth = btnFrame.width*sizeRatioToAnchor

            // Show quick operators
            let label = UILabel()

            // Quick operator type
            switch type {
            case .plus:
                label.text = "+"
                label.tag = QuickOperatorType.plus.rawValue
            case .minus:
                label.text = "–"
                label.tag = QuickOperatorType.minus.rawValue
            case .multiply:
                label.text = "×"
                label.tag = QuickOperatorType.multiply.rawValue
            case .divide:
                label.text = "÷"
                label.tag = QuickOperatorType.divide.rawValue
            case .none:
                label.text = ""
                label.tag = QuickOperatorType.divide.rawValue
            }

            // Quick operator position
            switch position {
            case .left:
                label.frame = CGRect(x: btnFrame.origin.x - opWidth - spaceToAnchor,
                                     y: btnFrame.origin.y + (btnFrame.height - opHeight)/2,
                                     width: opWidth,
                                     height: opHeight)
            case .right:
                label.frame = CGRect(x: btnFrame.origin.x + btnFrame.size.width + spaceToAnchor,
                                     y: btnFrame.origin.y + (btnFrame.height - opHeight)/2,
                                     width: opWidth,
                                     height: opHeight)
            case .top:
                label.frame = CGRect(x: btnFrame.origin.x + (btnFrame.width - opWidth)/2,
                                     y: btnFrame.origin.y - opHeight - spaceToAnchor,
                                     width: opWidth,
                                     height: opHeight)
            case .bottom:
                label.frame = CGRect(x: btnFrame.origin.x + (btnFrame.width - opWidth)/2,
                                     y: btnFrame.origin.y + btnFrame.size.height + spaceToAnchor,
                                     width: opWidth,
                                     height: opHeight)
            }
            JLog("Adding QO \(label.text ?? "nil") at", CGRect: label.frame)

            // Quick operator appearance
            label.textAlignment = .center
            label.textColor = .white
            if let btnLabel = button.titleLabel {
                label.font = .systemFont(ofSize: btnLabel.font.pointSize * sizeRatioToAnchor)
            } else {
                label.font = .systemFont(ofSize: 32.0 * sizeRatioToAnchor)
            }
            label.backgroundColor = .systemIndigo
            label.layer.masksToBounds = true
            label.layer.cornerRadius = cornerRadius

            superView.addSubview(label)
        }
    }

    // Remove added Quick Operator from the super view
    func remove(_ type: QuickOperatorType) {
        if let superView = superView {
            superView.viewWithTag(type.rawValue)?.removeFromSuperview()
        }
    }
}
