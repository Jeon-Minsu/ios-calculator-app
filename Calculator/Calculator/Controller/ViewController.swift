//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var stackview: UIStackView!
    @IBOutlet weak var resultOperator: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var formula: Formula = Formula(operands: CalculatorItemQueue<Double>(), operators: CalculatorItemQueue<String>())
    
    private var realInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetResultLabel()
        resetResultOperator()
        
        clearStackView()
    }
    
    @IBAction func touchNumberButton(_ sender: UIButton) {
        guard stackview.arrangedSubviews.count <= 0 || resultOperator.text != "" else {
            clearStackView()
            
            resultLabel.text = sender.currentTitle
            return
        }
        
        let digit = sender.currentTitle
        
        guard digit != "." || resultLabel.text!.filter({ $0 == "." }).count < 1 else {
            return
        }
        
        if let stringDigit: String = digit {
            if resultLabel.text! == "0" {
                resultLabel.text! = stringDigit
            } else if resultLabel.text! == "00" {
                resultLabel.text! = "0"
            } else {
                resultLabel.text! += stringDigit
            }
        }
        
        if resultLabel.text!.contains(".") == false {
            let result = convertResultLabel()
            formatCalculatorItems(number: result)
        }
        
    }
    
    @IBAction func touchOperatorButton(_ sender: UIButton) {
        guard resultLabel.text != "0" ||  stackview.arrangedSubviews.count > 0 else {
            return
        }
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        if Double(label1.text!) != 0.0 {
            if resultOperator.text == "" && stackview.arrangedSubviews.count > 0 {
                
                clearStackView()
                
                let result = convertResultLabel()
                formatCalculatorItems(number: result)
                
                label1.text = resultOperator.text! + " " + resultLabel.text!
                stackview.addArrangedSubview(label1)
                let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                
                realInput += trimmedInput
            } else {
                let result = convertResultLabel()
                formatCalculatorItems(number: result)
                
                label1.text = resultOperator.text! + " " + resultLabel.text!
                
                stackview.addArrangedSubview(label1)
                
                let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                
                realInput += trimmedInput

            }
        }
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        resetResultLabel()
        
        resultOperator.text = sender.currentTitle
        
        goToBottomOfScrollView()
    }
    
    @IBAction func touchResultButton(_ sender: UIButton) {
        guard resultOperator.text != "" else {
            return
        }
        
        let result = convertResultLabel()
        formatCalculatorItems(number: result)
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        
        
        label1.text = resultOperator.text! + " " + resultLabel.text!

        stackview.addArrangedSubview(label1)
        let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        realInput += trimmedInput
        
        formula = ExpressionParser.parse(from: realInput)
        
        resetResultOperator()
        
        do {            
            let result = try formula.result()
            formatCalculatorItems(number: result)
            
        } catch (let error) {
            switch error {
            case CalculatorError.dividedByZero:
                resultLabel.text = "NaN"
            case CalculatorError.notEnoughOperands:
                resultLabel.text = "not enough operands"
            case CalculatorError.notEnoughOperators:
                resultLabel.text = "not enough operators"
            case CalculatorError.emptyQueues:
                resultLabel.text = "empty queues"
            case CalculatorError.invalidOperator:
                resultLabel.text = "invalid operator"
            default:
                resultLabel.text = "unknown error"
            }
        }
        
        goToBottomOfScrollView()
        resetNumberInput()
    }
    
    @IBAction func touchAllClearButton(_ sender: UIButton) {
        clearStackView()
        resetResultLabel()
        resetResultOperator()
        resetNumberInput()
    }
    
    @IBAction func touchClearEntryButton(_ sender: UIButton) {
        resetResultLabel()
        
        if realInput == "" {
            clearStackView()
        }
    }
    
    @IBAction func touchSignChangerButton(_ sender: UIButton) {
        guard let trimmedResultLabel = resultLabel.text?.replacingOccurrences(of: ",", with: "") else {
            return
        }
        
        if Double(trimmedResultLabel) != 0 {
            resultLabel.text! = String(-Double(trimmedResultLabel)!)
            let result = convertResultLabel()
            formatCalculatorItems(number: result)
        }
        
    }
    
    func clearStackView() {
        while stackview.arrangedSubviews.count > 0
        {
            guard let last = stackview.arrangedSubviews.last else {
                return
            }
            
            self.stackview.removeArrangedSubview(last)
        }
    }
    
    func convertResultLabel() -> Double {
        let trimmedResultLabel = resultLabel.text?.replacingOccurrences(of: ",", with: "")
        let trimmedResultLabelToDouble = Double(trimmedResultLabel!)!
        return trimmedResultLabelToDouble
    }
    
    func formatCalculatorItems(number: Double) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 20
        numberFormatter.maximumIntegerDigits = 20
        
        guard let formattedResult = numberFormatter.string(from: number as NSNumber) else {
            return
        }
        
        resultLabel.text! = formattedResult
    }
    
    func goToBottomOfScrollView() {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: scrollView.contentSize.height - scrollView.bounds.height),
                                    animated: true)
    }
    
    func resetResultLabel() {
        resultLabel.text = "0"
    }
    
    func resetResultOperator() {
        resultOperator.text = ""
    }
    
    func resetNumberInput() {
        realInput = ""
    }
    
}

// 4. 스택뷰 왼쪽에 뜨는거 안 없어져서 그런것 같은데?

