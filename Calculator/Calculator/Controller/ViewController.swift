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
    
    private var realInput = ""
    
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
            let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
            
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
        let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")

        
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
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
//            numberFormatter.maximumFractionDigits = -2 //소수점 최대 자릿수
//            numberFormatter.roundingMode = .up
//            numberFormatter.maximumIntegerDigits = 20
//            numberFormatter.maximumSignificantDigits = 20
//            numberFormatter.minimumSignificantDigits = 3  // 자르길 원하는 자릿수
            
//            numberFormatter.roundingMode = .up
//
            numberFormatter.maximumFractionDigits = 20
            numberFormatter.maximumIntegerDigits = 20
            
//            numberFormatter.usesSignificantDigits = true
//            numberFormatter.maximumSignificantDigits = 20
            
            
            let formattedResult = numberFormatter.string(from: try formula.result() as NSNumber)
            resultLabel.text = formattedResult
//            resultLabel.text = String(try formula.result())
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
        if Double(resultLabel.text!)! != 0 {
            resultLabel.text! = String(-Double(resultLabel.text!)!)
        }
        
    }
}

// 1. 스택뷰 아래로 최신화 되게
// 2. = 버튼을 눌러 연산을 마친 후 다시 =을 눌러도 이전 연산을 다시 연산하지 않습니다
// 3. 결과값 나온 다음 또 숫자 입력하면 현재 결과값이 스택뷰로 올라가고 다시 새로운 숫자가 입력되게 해야하나?
// 4. 스택뷰 왼쪽에 뜨는거 안 없어져서 그런것 같은데?
