//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var stackview: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
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
        var a = ExpressionParser.parse(from: resultLabel.text!)
        print(a.operands.queue.peek)
        
        
        let label = UILabel()
        label.isHidden = true
        label.text = resultLabel.text
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        stackview.addArrangedSubview(label)
        
        
        UIView.animate(withDuration: 0.3) {
            label.isHidden = false
        }
        
        resultLabel.text = "0"
    }
    @IBAction func addView() {
        // 스크롤이 화면을 넘어가면 밑에것이 주목되게!
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "123123123"
//        label.numberOfLines = 0
//        label.textColor = .white
//        label.font = UIFont.preferredFont(forTextStyle: .title3)
//        label.adjustsFontForContentSizeCategory = true
//        stackview.addArrangedSubview(label)
//
//
//        UIView.animate(withDuration: 0.3) {
//            label.isHidden = false
//        }
        
    }
}
