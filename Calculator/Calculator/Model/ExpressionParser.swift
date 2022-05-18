//
//  ExpressionParser.swift
//  Calculator
//
//  Created by 전민수 on 2022/05/18.
//
enum ExpressionParser {
    func parse(fomr input: String) -> Formula {
        return Formula(operands: CalculatorItemQueue<Double>(), operators: CalculatorItemQueue<String>())
    }
    
    private func componentsByOperators(from input: String) -> [String] {
        return ["+"]
    }
}
