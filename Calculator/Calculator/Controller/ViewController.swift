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
    
    var formula: Formula = Formula(operands: CalculatorItemQueue<Double>(), operators: CalculatorItemQueue<String>())
    
    var realInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
        resultOperator.text = ""
        
        // 왼쪽으로 튀어나오고 난리났음 수정 필요!
        while stackview.arrangedSubviews.count > 0
        {
            guard let last = stackview.arrangedSubviews.last else {
                return
            }
            
            self.stackview.removeArrangedSubview(last)
        }
        print("−" == "-")
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        
        
        
        
        //        if let digit2 = Double(digit) {
        //            print("\(digit2) touched")
        //            resultLabel.text! += String(digit2)
        //        }
    }
    
    @IBAction func touchNumberButton(_ sender: UIButton) {
        // 처음 0으로 시작하는데
        // 숫자가 입력되면 0을 없애야함
        let digit = sender.currentTitle
        
        if let stringDigit: String = digit {
            if resultLabel.text! == "0" {
                resultLabel.text! = digit!
            } else if resultLabel.text! == "00" {
                resultLabel.text! = "0"
            } else {
                resultLabel.text! += stringDigit
            }
        }
        
    }
    
    @IBAction func touchOperatorButton(_ sender: UIButton) {
        // 연산자가 입력되면 결과label을 0으로 만들고
        // 결과 label에 이때까지 입력된 값을 스크롤뷰 내 stackView로 올려야함
        // 스크롤뷰 내 스택뷰 기본값 없애야 함!
        
        
        // 이 값은 나중에 계산할때만 쓰면 되는건가?
        //        formula = ExpressionParser.parse(from: resultLabel.text!)
        //        formula = ExpressionParser.parse(from: resultOperator.text!)
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        if Double(label1.text!) != 0.0 {
            label1.text = resultOperator.text! + " " + resultLabel.text!
            stackview.addArrangedSubview(label1)
            let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "")
            
            print("trimmed input = \(trimmedInput)")
            //            formula = ExpressionParser.parse(from: trimmedInput)
            realInput += trimmedInput
            print(realInput)
        }
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        // 0이면 사칙연산자 안 되게!
        //        if realInput.isEmpty == true {
        //            if Double(label1.text!) != 0.0 {
        //                label1.text = resultOperator.text! + " " + resultLabel.text!
        //                stackview.addArrangedSubview(label1)
        //                let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "")
        //
        //                print("trimmed input = \(trimmedInput)")
        //                //            formula = ExpressionParser.parse(from: trimmedInput)
        //                realInput += trimmedInput
        //                print(realInput)
        //            }
        //        } else {
        //            label1.text = resultOperator.text! + " " + resultLabel.text!
        //            stackview.addArrangedSubview(label1)
        //            let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "")
        //
        //            print("trimmed input = \(trimmedInput)")
        //            //            formula = ExpressionParser.parse(from: trimmedInput)
        //            realInput += trimmedInput
        //            print(realInput)
        //        }
        
        resultLabel.text = "0"
        
        
        resultOperator.text = sender.currentTitle
        
        
        
        print(formula.operands.queue.enqueueStack)
        print(formula.operators.queue.enqueueStack)
        print(formula.operands.queue.dequeueStack)
        print(formula.operators.queue.dequeueStack)
    }
    
    @IBAction func touchResultButton(_ sender: UIButton) {
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        
        label1.text = resultOperator.text! + " " + resultLabel.text!
        print("labe1.text = \(label1.text ?? "0")")
        stackview.addArrangedSubview(label1)
        let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "")
        
        print("trimmed input = \(trimmedInput)")
        //            formula = ExpressionParser.parse(from: trimmedInput)
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        realInput += trimmedInput
        print(realInput)
        
        
//        realInput += resultOperator.text!
//        realInput += resultLabel.text!
//        print(realInput)
        
        formula = ExpressionParser.parse(from: realInput)
        
        resultOperator.text = ""
        
        print(formula.operands.queue.enqueueStack)
        print(formula.operators.queue.enqueueStack)
        print(formula.operands.queue.dequeueStack)
        print(formula.operators.queue.dequeueStack)
        

        
        do {
            resultLabel.text = String(try formula.result())
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
        
        realInput = ""
        
        
    }
    
    @IBAction func touchAllClearButton(_ sender: UIButton) {
        while stackview.arrangedSubviews.count > 0
        {
            guard let last = stackview.arrangedSubviews.last else {
                return
            }
            
            self.stackview.removeArrangedSubview(last)
        }
        
        resultLabel.text = "0"
        resultOperator.text = ""
        realInput = ""
    }
    
    @IBAction func touchClearEntryButton(_ sender: UIButton) {
        resultLabel.text = "0"
        
        if realInput == "" {
            while stackview.arrangedSubviews.count > 0
            {
                guard let last = stackview.arrangedSubviews.last else {
                    return
                }
                
                self.stackview.removeArrangedSubview(last)
            }
        }
    }
    
    @IBAction func touchSignChangerButton(_ sender: UIButton) {
        resultLabel.text! = String(-Double(resultLabel.text!)!)
    }
}
