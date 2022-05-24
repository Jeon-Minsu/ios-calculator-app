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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
        resultOperator.text = ""
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
            } else {
                resultLabel.text! += stringDigit
            }
        }
    }
    
    @IBAction func touchOperatorButton(_ sender: UIButton) {
        // 연산자가 입력되면 결과label을 0으로 만들고
        // 결과 label에 이때까지 입력된 값을 스크롤뷰 내 stackView로 올려야함
        // 은닉화 풀렸으니 다시 걸어줘야함 잊지말기
        
        // 이 값은 나중에 계산할때만 쓰면 되는건가?
        ExpressionParser.parse(from: resultLabel.text!)
        
        let label1 = UILabel()
        label1.isHidden = true
        label1.text = resultLabel.text!
        label1.numberOfLines = 0
        label1.textColor = .white
        label1.font = UIFont.preferredFont(forTextStyle: .title3)
        label1.adjustsFontForContentSizeCategory = true
        
        // 0이면 사칙연산자 안 되게!
        if Double(label1.text!) != 0.0 {
            label1.text = resultOperator.text! + " " + resultLabel.text!
            stackview.addArrangedSubview(label1)
        }
        
        UIView.animate(withDuration: 0.3) {
            label1.isHidden = false
        }
    
        resultLabel.text = "0"

        resultOperator.text = sender.currentTitle
    }
}
