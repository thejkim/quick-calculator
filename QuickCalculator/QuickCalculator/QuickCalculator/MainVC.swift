//
//  MainVC.swift
//  QuickCalculator
//
//  Created by Joeun Kim on 10/19/21.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var labelCurrentInput: UILabel!
    var currentOperator:QuickOperatorType = .none
    var enterDecimal:Bool = false
    var enterNewTerm:Bool = true
    var currentInput:Double = 0.0 // user input OR evaluation result
    var termLeft:Double = 0.0
    var termRight:Double = 0.0

    let numberformatter = NumberFormatter()
    let quickOperator = QuickOperator(cornerRadius: 20.0, sizeRatio: 0.8, space: 12.0)

    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        labelCurrentInput.adjustsFontSizeToFitWidth = true
        labelCurrentInput.text = "0"

        numberformatter.numberStyle = .decimal
        numberformatter.groupingSeparator = ","
        
        quickOperator.superView = self.view
    }

    // MARK: - IBAction
    // [0-9] Button : Show quick operator views
    @IBAction func btnTouchDownNumberPad(_ sender: UIButton, forEvent event: UIEvent) {
        quickOperator.add(.plus, at: .right, for: sender)
        quickOperator.add(.minus, at: .left, for: sender)
        quickOperator.add(.multiply, at: .top, for: sender)
        quickOperator.add(.divide, at: .bottom, for: sender)
    }

    // [0-9] Button : Enter quick operator or Number
    @IBAction func btnTouchUpInNumberPad(_ sender: UIButton, forEvent event: UIEvent) {
        // Get current touch location
        let size = sender.frame.size
        guard let touch = event.allTouches?.first else { return }
        let touchLocation = touch.location(in: sender)
        JLog("Touch Location: \(touchLocation)")

        // Number input
        if sender.tag < 10 {
            if enterNewTerm { // new term input
                JLog("User Input (new) : \(sender.tag)")
                currentInput = Double(sender.tag)
                if sender.tag > 0 { // not to add leading 0
                    enterNewTerm = false
                }
            } else { // add to the current term value
                JLog("Enter Number (add) \(sender.tag)")
                if let text = labelCurrentInput.text {
                    let inputText = "\(currentInput == 0.0 && enterDecimal == false ? "" : text)\(sender.tag)".replacingOccurrences(of: numberformatter.groupingSeparator, with: "")
                    currentInput = Double(inputText) ?? 0.0
                }
            }
        }

        // if touch ended within the quick operator enter range, enter an operator. Otherwise, enter a number
        if touchLocation.x < 0 { // Minus
            JLog("User Input : -")
            if currentOperator == .none {
                termLeft = currentInput
                enterNewTerm = true
            } else {
                termRight = currentInput
                evaluate()
            }
            currentOperator = .minus
        } else if touchLocation.x > size.width { // Plus
            JLog("User Input : +")
            if currentOperator == .none {
                termLeft = currentInput
                enterNewTerm = true
            } else {
                termRight = currentInput
                evaluate()
            }
            currentOperator = .plus
        } else if touchLocation.y < 0 { // Multiply
            JLog("User Input : *")
            if currentOperator == .none {
                termLeft = currentInput
                enterNewTerm = true
            } else {
                termRight = currentInput
                evaluate()
            }
            currentOperator = .multiply
        } else if touchLocation.y > size.height { // Divide
            JLog("User Input : /")
            if currentOperator == .none {
                termLeft = currentInput
                enterNewTerm = true
            } else {
                termRight = currentInput
                evaluate()
            }
            currentOperator = .divide
        }
        updateCurrentInputLabel()

        quickOperator.remove(.plus)
        quickOperator.remove(.minus)
        quickOperator.remove(.multiply)
        quickOperator.remove(.divide)
    }

    // [0-9] Button : Cancel input & hide quick operator views
    @IBAction func btnTouchUpOutNumberPad(_ sender: UIButton, forEvent event: UIEvent) {
        quickOperator.remove(.plus)
        quickOperator.remove(.minus)
        quickOperator.remove(.multiply)
        quickOperator.remove(.divide)
    }

    // [Clear] button : Clear all previous inputs
    @IBAction func btnTouchUpInClear(_ sender: UIButton) {
        currentOperator = .none
        enterDecimal = false
        enterNewTerm = true
        termLeft = 0.0
        termRight = 0.0
        currentInput = 0.0
        currentInput = 0.0
        labelCurrentInput.text = "0"
        updateCurrentInputLabel()
    }

    // [.  +/-  =] Button : Enter regular operator
    @IBAction func btnTouchUpInOperator(_ sender: UIButton, forEvent event: UIEvent) { // TODO: RENAME! THESE ARE NOT OPERATORS
        // if the result label text not unwrapped, set it to 0
        guard let string = labelCurrentInput.text else {
            labelCurrentInput.text = "0"
            return
        }
        switch sender.tag {
        case 11: // button .
            if string.firstIndex(of: ".") == nil {
                enterDecimal = true
                labelCurrentInput.text = "\(string)."
                enterNewTerm = false
            }
        case 12: // button +/-
            // + to -
            if currentInput > 0.0 {
                labelCurrentInput.text = "-\(string)"
            } else if currentInput < 0.0 {
            // - to +
                let range = string.index(after: string.startIndex)...
                labelCurrentInput.text = String(string[range])
            }
            currentInput *= -1
            if termRight == 0.0 {
                termLeft = currentInput
            } else {
                termRight = currentInput
            }
        default: // button =
            termRight = currentInput
            evaluate()
            updateCurrentInputLabel()
            currentOperator = .none

            // Show Quick Operators
            btnTouchUpInNumberPad(sender, forEvent: event)
        }
    }

    // MARK: - UI View Control
    func updateCurrentInputLabel() {
        labelCurrentInput.text = numberformatter.string(for: currentInput)
    }
    
    // MARK: - UI Touch Event
    // touch event for other than UIButton
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    // MARK: - Handling Equation
    func evaluate() {
        JLog("Evaluating \(termLeft) and \(termRight)")
        switch currentOperator {
        case .none:
            break
        case .plus:
            currentInput = termLeft + termRight
        case .minus:
            currentInput = termLeft - termRight
        case .multiply:
            currentInput = termLeft * termRight
        case .divide:
            currentInput = termLeft / termRight
        }
        termLeft = currentInput
        termRight = 0.0
        currentOperator = .none
        enterNewTerm = true
    }
}
