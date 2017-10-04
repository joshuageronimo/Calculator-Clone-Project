////
////  CalculatorBrain.swift
////  Calculator Clone Project
////
////  Created by Joshua Geronimo on 8/7/17.
////  Copyright © 2017 Joshua Geronimo. All rights reserved.

import Foundation

struct CalculatorBrain {
    // this variable will be the accumalor of input from the user
    private var accumalator: Double?
    
    // this function will take the input from the user and save it to the accumalator variable
    mutating func operand(_ number: Double) {
        accumalator = number
    }
    
    // This is an enumaration of operations
    enum Operations {
        case constant(Double)                   // takes a Double
        case unary((Double) -> Double )         // function that takes a Double and returns a Double
        case binary((Double, Double) -> Double) // function that takes 2 Doubles and returns a Double
        case equals                             // non-associated case
    }
    
    // this is a Dictionary for the different types of operation symbols
    var operationDictionary: [String : Operations] = ["AC" : Operations.constant(0.0),
                                                      "±" : Operations.unary({-$0}),
                                                      "%" : Operations.unary({$0 / 100.0}),
                                                      "÷" : Operations.binary({$0 / $1}),
                                                      "×" : Operations.binary({$0 * $1}),
                                                      "−" : Operations.binary({$0 - $1}),
                                                      "+" : Operations.binary({$0 + $1}),
                                                      "=" : Operations.equals
    ]
    
    // this function decideds which what Operation case to perform
    mutating func performOperation(_ symbol: String) {
        if let operation = operationDictionary[symbol] {
            switch operation {
            case .constant(let value):
                accumalator = value
            case .unary(let value):
                if accumalator != nil {
                    accumalator = value(accumalator!)
                }
            case .binary(let binaryFunction):
                if accumalator != nil {
                    pendingBinaryOperation = PendingBinaryOperation.init(firstOperand: accumalator!, function: binaryFunction)
                    accumalator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // called when .equals is called
    mutating func performPendingBinaryOperation() {
        if accumalator != nil {
            accumalator = pendingBinaryOperation?.performOperation(with: accumalator!)
        }
    }
    
    // declare a reference variable for PendingBinaryOperation
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    //This struct is called when .binary is called.
    struct PendingBinaryOperation {
        var firstOperand: Double
        var function: (Double, Double) -> Double
        
        func performOperation(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // getter that returns the result (Double)
    var result: Double? {
        get {
            return accumalator
        }
    }
}
