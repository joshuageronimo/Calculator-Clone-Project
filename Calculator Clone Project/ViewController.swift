//
//  ViewController.swift
//  Calculator Clone Project
//
//  Created by Joshua Geronimo on 8/6/17.
//  Copyright © 2017 Joshua Geronimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // The label that shows the input and output of the user
    @IBOutlet weak var display: UILabel!
    // A boolean variable to keep track wether a user is typing or not (Default: False)
    var userIsInTheMiddleOfTyping = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This IBAction is connected to the number buttons
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit: String = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            if (display.text?.contains("."))! {
                if digit != "." {
                    display.text?.append(digit)
                }
            } else {
                display.text?.append(digit)
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    /*
     This getter and setter variable cast's the return value to Double
     and cast's the newValue to a String. This will help make performOperation()'s
     code shorter and "swifty"
     */
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var calcBrain = CalculatorBrain()
    
    @IBAction func performOperations(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            calcBrain.operand(displayValue)
            calcBrain.performOperation(operation)
            userIsInTheMiddleOfTyping = false
        } else {
            /*
             the if statement is for when the app first opens and a user
             tries to perform an operation. Without this, when the user presses
             an operation, nothing will happen, since the default for @userIsInTheMiddleOfTyping
             is false, calcBrain.operand wouldn't have been called yet to get the value of the current display.
             */
            if displayValue == 0 {
                calcBrain.operand(displayValue)
            }
            calcBrain.performOperation(operation)
        }
        
        if let result = calcBrain.result {
            displayValue = result
        }
    }
}

