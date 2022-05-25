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
        resultLabel.text = "0"
        resultOperator.text = ""
        
        // 왼쪽으로 튀어나오고 난리났음 수정 필요!
        clearStackView()
    }
    
    @IBAction func touchNumberButton(_ sender: UIButton) {
        guard stackview.arrangedSubviews.count <= 0 || resultOperator.text != "" else {
            clearStackView()
            
            resultLabel.text = sender.currentTitle
            return
        }
        
        
        
        let digit = sender.currentTitle
        
        guard digit != "." || resultLabel.text!.filter { $0 == "." }.count < 1 else {
            return
        }
        
        if let stringDigit: String = digit {
            if resultLabel.text! == "0" {
                resultLabel.text! = stringDigit
            } else if resultLabel.text! == "00" {
                resultLabel.text! = "0"
            } else {
                resultLabel.text! += stringDigit
                
                
//                formatNumber()
                
//                let trimmedResultLabel = resultLabel.text?.replacingOccurrences(of: ",", with: "")
//                let numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = .decimal
//                numberFormatter.maximumFractionDigits = 20
//                numberFormatter.maximumIntegerDigits = 20
//                let formattedResult = numberFormatter.string(from: Double(trimmedResultLabel!)! as NSNumber)
//
//                resultLabel.text! = formattedResult!
            }
        }
        
        if resultLabel.text!.contains(".") == false {
            formatNumber()
        }
        
    }
    
    @IBAction func touchOperatorButton(_ sender: UIButton) {
        // 연산자가 입력되면 결과label을 0으로 만들고
        // 결과 label에 이때까지 입력된 값을 스크롤뷰 내 stackView로 올려야함
        // 스크롤뷰 내 스택뷰 기본값 없애야 함!
        
        
        
        //        guard stackview.arrangedSubviews.count >= 0 || resultOperator.text != "" else {
        //            return
        //        }
        //
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
                
                formatNumber()
                
                label1.text = resultOperator.text! + " " + resultLabel.text!
                stackview.addArrangedSubview(label1)
                let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                
                print("trimmed input = \(trimmedInput)")
                //            formula = ExpressionParser.parse(from: trimmedInput)
                realInput += trimmedInput
                print(realInput)
                
            } else {
                
                
                formatNumber()
//                let trimmedResultLabel = resultLabel.text?.replacingOccurrences(of: ",", with: "")
//                let numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = .decimal
//                numberFormatter.maximumFractionDigits = 20
//                numberFormatter.maximumIntegerDigits = 20
//                let formattedResult = numberFormatter.string(from: Double(trimmedResultLabel!)! as NSNumber)
//
//                resultLabel.text! = trimmedResultLabel!
                
                label1.text = resultOperator.text! + " " + resultLabel.text!
                
                stackview.addArrangedSubview(label1)
                
                let trimmedInput = label1.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                
                realInput += trimmedInput
                print(realInput)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
        
        
        resultLabel.text = "0"
        
        
        resultOperator.text = sender.currentTitle
        
        
        
        print(formula.operands.queue.enqueueStack)
        print(formula.operators.queue.enqueueStack)
        print(formula.operands.queue.dequeueStack)
        print(formula.operators.queue.dequeueStack)
        
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: scrollView.contentSize.height - scrollView.bounds.height),
                                    animated: true)
    }
    
    @IBAction func touchResultButton(_ sender: UIButton) {
        guard resultOperator.text != "" else {
            return
        }
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        formatNumber()
        
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
        clearStackView()
        
        resultLabel.text = "0"
        resultOperator.text = ""
        realInput = ""
    }
    
    @IBAction func touchClearEntryButton(_ sender: UIButton) {
        resultLabel.text = "0"
        
        if realInput == "" {
            clearStackView()
        }
    }
    
    @IBAction func touchSignChangerButton(_ sender: UIButton) {
        if Double(resultLabel.text!)! != 0 {
            resultLabel.text! = String(-Double(resultLabel.text!)!)
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
    
    func formatNumber() {
        let trimmedResultLabel = resultLabel.text?.replacingOccurrences(of: ",", with: "")
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 20
        numberFormatter.maximumIntegerDigits = 20
        let formattedResult = numberFormatter.string(from: Double(trimmedResultLabel!)! as NSNumber)
        
        resultLabel.text! = formattedResult!
    }
}

// 4. 스택뷰 왼쪽에 뜨는거 안 없어져서 그런것 같은데?
// 끝난 연산 결과에 대하여 양음 부호 전환이 가능하게
// 00 인 경우 +-*/ 안눌리게 수정하기
// 숫자 도중 소수점이 안됨


//- 계산기 내 모든 숫자에 대하여 포맷 추가 ( 추후 함수로 빼낼 예정)
//- 처음 시작시 0일 경우 연산자 기호가 안눌리게 (추후 00도 처리 예정)
//- =이 자꾸 입력될 때 안 먹히게 하기 (이거 때문에 끝난 연산 결과에 대하여 양음 부호 전환이 가능하게하는게 안되는듯?)

