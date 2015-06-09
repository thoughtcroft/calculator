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
    
    var brain = CalculatorBrain()

    // manage aspects of applying operations to
    // the operands on the stack
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = nil
        }
        if !history.text!.hasSuffix(operation) {
            history.text = history.text! + operation
        }
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
    }
    
    // keys that are not operations but control
    // adding and removing numbers in the display
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingNumber {
            if isCharNumeric(getLastChar(history.text)) {
                history.text = history.text! + "⏎"
            }
            userIsInTheMiddleOfTypingNumber = false
        }
        history.text = history.text! + display.text!
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
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
  
    @IBAction func clear(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            if count(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                displayValue = nil
                userIsInTheMiddleOfTypingNumber = false
            }
        } else {
            displayValue = nil
            history.text = ""
            brain.clearStack()
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    // manage displays and other useful things
    
    var displayValue: Double? {
        get {
            println("display = \(display.text!)")
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            if newValue == nil {
                display.text = "0"
            } else {
                display.text = "\(newValue!)"
            }
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    

    func getLastChar(text: String?) -> Character? {
        if text != nil && count(text!) > 0 {
            if let ch = text![text!.endIndex.predecessor()] as Character? {
                return ch
            }
        }
        return nil
    }
    
    func isCharNumeric(char: Character?) -> Bool {
        var result = false
        if char != nil {
            if let n = String(char!).toInt() {
                result = true
            }
        }
        return result
    }
}
