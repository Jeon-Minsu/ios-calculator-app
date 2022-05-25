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
        
        guard var text = resultLabel.text else {
            return
        }
        
        guard digit != "." || text.filter({ $0 == "." }).count < 1 else {
            return
        }
        
        guard let unwrappedDigit: String = digit else {
            return
        }
        
        if text == "0" {
            resultLabel.text = unwrappedDigit
        } else if text == "00" {
            resultLabel.text = "0"
        }
        
//        guard Double(unwrappedDigit) != 0.0 else {
//            text = "0"
//            resultLabel.text = text
//            return
//        }
        
        
        text += unwrappedDigit
        resultLabel.text = text
        

              
        guard text.contains(".") == false else {
            return
        }
        
        guard let result = convertResultLabel() else {
            return
        }
        formatCalculatorItems(number: result)
        
    }
    
    @IBAction func touchOperatorButton(_ sender: UIButton) {
//        guard let resultLabel = resultLabel else {
//            return
//        }
//
//        guard case resultLabel.text = resultLabel.text else {
//            return
//        }
        
        guard resultLabel.text != "0" ||  stackview.arrangedSubviews.count > 0 else {
            return
        }
        
        guard let text = resultLabel.text else {
            return
        }
        
        guard Double(text) != 0.0 else {
            return
        }
        
        if resultOperator.text == "" && stackview.arrangedSubviews.count > 0 {
            clearStackView()
        }
        
        addCalculatorItems()
        resultOperator.text = sender.currentTitle
        resetResultLabel()
        goToBottomOfScrollView()
    }
    
    @IBAction func touchResultButton(_ sender: UIButton) {
        guard resultOperator.text != "" else {
            return
        }
        
        addCalculatorItems()
        
        var formula = ExpressionParser.parse(from: realInput)
        
        do {            
            let result = try formula.result()
            formatCalculatorItems(number: result)
        } catch (let error) {
            switch error {
            case CalculatorError.dividedByZero:
                resultLabel.text = CalculatorError.dividedByZero.localizedDescription
            case CalculatorError.notEnoughOperands:
                resultLabel.text = CalculatorError.notEnoughOperands.localizedDescription
            case CalculatorError.notEnoughOperators:
                resultLabel.text = CalculatorError.notEnoughOperators.localizedDescription
            case CalculatorError.emptyQueues:
                resultLabel.text = CalculatorError.emptyQueues.localizedDescription
            case CalculatorError.invalidOperator:
                resultLabel.text = CalculatorError.invalidOperator.localizedDescription
            default:
                resultLabel.text = "unknown error"
            }
        }
        
        resetResultOperator()
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
        guard let trimmedResultLabelToDouble = convertResultLabel() else {
            return
        }
        
        guard trimmedResultLabelToDouble != 0 else {
            return
        }
        
        resultLabel.text = String(-trimmedResultLabelToDouble)
        
        guard let result = convertResultLabel() else {
            return
        }
        
        formatCalculatorItems(number: result)
    }
    
    func clearStackView() {
        while stackview.arrangedSubviews.count > 0 {
            guard let last = stackview.arrangedSubviews.last else {
                return
            }
            
            self.stackview.removeArrangedSubview(last)
        }
    }
    
    func convertResultLabel() -> Double? {
        guard let text = resultLabel.text else {
            return nil
        }
        
        let trimmedResultLabel = text.replacingOccurrences(of: ",", with: "")
        
        guard let trimmedResultLabelToDouble = Double(trimmedResultLabel) else {
            return nil
        }
        
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
        
        resultLabel.text = formattedResult
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
    
    func addCalculatorItems() {
        guard let result = convertResultLabel() else {
            return
        }
        formatCalculatorItems(number: result)
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        guard let operatorText = resultOperator.text else {
            return
        }
        
        guard let resultLabelText = resultLabel.text else {
            return
        }
        
        label1.text = operatorText + " " + resultLabelText
        
        stackview.addArrangedSubview(label1)
        
        guard let labelText = label1.text else {
            return
        }
        
        let whitespacesRemovedInput = labelText.replacingOccurrences(of: " ", with: "")
        let commaRemovedInput = whitespacesRemovedInput.replacingOccurrences(of: ",", with: "")
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        realInput += commaRemovedInput
    }
}

// 4. 스택뷰 왼쪽에 뜨는거 안 없어져서 그런것 같은데?

