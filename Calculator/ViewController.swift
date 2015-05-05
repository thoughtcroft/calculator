//
//  ViewController.swift
//  Calculator
//
//  Created by Warren Bain on 3/05/2015.
//  Copyright (c) 2015 Thought Croft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false

    // manage aspects of applying operations to
    // the operands on the stack
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        addHistory(operation)
        println("operation = \(operation)")
        switch operation {
        case "×": performOperation { $1 * $0 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $1 + $0 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation(M_PI)
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double) {
        displayValue = operation
        enter()
    }
    
    var operandStack = Array<Double>()
    
    // keys that are not operations but control
    // adding and removing numbers in the display
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        addHistory(display.text!)
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func removeDigit(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            if count(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                display.text = "0"
                userIsInTheMiddleOfTypingNumber = false
            }
        }
    }
    
    
    @IBAction func appendDecimal(sender: UIButton) {
        if display.text!.rangeOfString(".") == nil {
            appendDigit(sender)
        }
    }
    
    @IBAction func reverseSign(sender: UIButton) {
        if display.text!.hasPrefix("-") {
            display.text = dropFirst(display.text!)
        } else {
            display.text = "-" + display.text!
        }
    }
  
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    // manage the history of operands and operations
    // and how that is updated into the display
    
    var historyStack = Array<String>()
    
    func addHistory(item: String) {
        historyStack.append(item)
        updateHistory()
    }
    
    func removeHistory(count: Int) {
        if count == 0 {
            historyStack.removeAll()
        } else {
            for i in 1...min(count, historyStack.count) {
                historyStack.removeLast()
            }
        }
        updateHistory()
    }
    
    func updateHistory() {
        history.text = historyStack.reduce("") { $1 + "\n" + $0! }
    }
}
