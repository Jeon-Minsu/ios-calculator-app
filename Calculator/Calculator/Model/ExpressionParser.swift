//
//  ExpressionParser.swift
//  Calculator
//
//  Created by 전민수 on 2022/05/18.
//
enum ExpressionParser {
    func parse(from input: String) -> Formula {
        let operators = componentsByOperators(from: input)
        let operands = input.split { operators.contains(String($0))}.map {String($0)}
        
        var operatorsQueue = CalculatorItemQueue<String>()
        var operandsQueue = CalculatorItemQueue<Double>()
        
        // [해결해야할 점] for 문을 사용하지 않고 각 요소를 넣는 방법은 없을까?
        
//        for i in 0..<operators.count {
//            operatorsQueue.queue.enqueue(element: operators[i])
//        }
        
        operators.forEach { operatorsQueue.queue.enqueue(element: $0)
        }
        
//        for j in 0..<operands.count {
//            operandsQueue.queue.enqueue(element: Double(operands[j]) ?? 0.0)
//        }
        
        operands.forEach { operandsQueue.queue.enqueue(element: Double($0) ?? 0.0)
        }
        
        // print를 통해 각각의 큐에 들어가는 것 확인
//        print(operandsQueue.queue.enqueueStack)
//        print(operatorsQueue.queue.enqueueStack)
        
        // [해결해야할 점] extension String 이용하고자 했지만 아직 답을 못 찾는중 1
//        let operands = input.split(with: operators)
//        let operands = input.map { (value) -> String in
//            return String(value).split(with: operators)
//        }
//        let operands = input.components(separatedBy: Set(a))
        
        
        // [해결해야할 점] extension String 이용하고자 했지만 아직 답을 못 찾는중 2
//        let a = operators.map { Character($0) }
//        let operands = input.split(with: a[0])
//        let operands = input.split(with: a.filter { $0 == "+" })
        
    
        return Formula(operands: operandsQueue, operators: operatorsQueue)
    }
    
    private func componentsByOperators(from input: String) -> [String] {
        let operators = input.filter { $0.isNumber == false }.map { String($0) }
        return operators
    }
}

