//
//  Formula.swift
//  Calculator
//
//  Created by 전민수 on 2022/05/18.
//
struct Formula {
    let operands: CalculatorItemQueue<Double>
    let operators: CalculatorItemQueue<String>
    
    func result() -> Double {
        
        // 연산큐<String>에 들어온 연산자(string)을 받음.
        // 이를 operator 열거형 내 case와 대응시켜야함
        let a = operators.queue.enqueueStack[0] // a는 String 타입
        let b = Operator(rawValue: Character(a))
        
        
        // 대응하여 알게된 case를 통해 어떤 연산자인지 알게 되어
        // calculate 사용시
        // 연산큐<Double>에 들어온 연산 대상이 되는 실수(Double)을 받았단 전제 하
        // 연상 대상이 되는 실수의 첫번째 값과 두번째 ㄱ밧을
        // 각각 calculate 메서드 파라미터의 좌변과 우변에 대입
        let c = operands.queue.enqueueStack[0]
        let d = operands.queue.enqueueStack[1]
        
        
        let result = b?.calculate(lhs: c, rhs: d)
        
        
//         [해결해야할 점] enqueueStack과 queue에 접근하기 위하여 접근 제어를 삭제했음
//         [해결해야할 점] 인덱스 관련 연산자와 피연산수의 구분은 count를 통해 대응시키면 될 것 같은데?
//         [해결해야할 점] 아니면, 고차함수 filter를 통하여 실수값은 operands에,
//         String 값은 operator에 넣을 수도 있을 듯?
//         [해결해야할 점] 고차함수 reduce를 이용하여 연산을 처리할 수 없을까?
        
        return result ?? 0
    }
    
    // 실행코드
//    var a = CalculatorItemQueue<Double>()
//    a.queue.enqueue(element: 10)
//    a.queue.enqueue(element: 20)
//    var b = CalculatorItemQueue<String>()
//    b.queue.enqueue(element: "+")
//    let formula = Formula(operands: a, operators: b)
//    print(formula.result())
}


