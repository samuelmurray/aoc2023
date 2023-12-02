import Foundation
import utils

public func getNumber(_ input: String) -> Int {
    var digits: [Character] = []
    for char in input {
        if let _ = char.wholeNumberValue {
            digits.append(char)
        }
    }
    let number = "\(digits.first!)\(digits.last!)"
    return Int(number)!
}

public func computeSum(_ input: [String]) -> Int {
    let numbers = input.map { line in replaceTextWithDigits(line) }.map { line in 
        getNumber(line)
    }
    return numbers.reduce(0, +)
}

public func replaceTextWithDigits(_ input: String) -> String {
    var output = ""
    var suffix: String = input
    while suffix.count > 0 {
        let result = replacePrefixWithDigit(suffix)
        output = "\(output)\(result.prefix)"
        suffix = result.suffix
    }
    return output
}

public func replacePrefixWithDigit(_ input: String) -> (prefix: String, suffix: String) {
    switch input {
    case _ where input.starts(with: "zero"): return ("0", input.suffix(from: "zero".count))
    case _ where input.starts(with: "one"): return ("1", input.suffix(from: "one".count))
    case _ where input.starts(with: "two"): return ("2", input.suffix(from: "one".count))
    case _ where input.starts(with: "three"): return ("3", input.suffix(from: "three".count))
    case _ where input.starts(with: "four"): return ("4",input.suffix(from: "four".count))
    case _ where input.starts(with: "five"): return ("5",input.suffix(from: "five".count))
    case _ where input.starts(with: "six"): return ("6",input.suffix(from: "six".count))
    case _ where input.starts(with: "seven"): return ("7",input.suffix(from: "seven".count))
    case _ where input.starts(with: "eight"): return ("8",input.suffix(from: "eight".count))
    case _ where input.starts(with: "nine"): return ("9", input.suffix(from: "nine".count))
    default:
        return (String(input.first!), String(input.suffix(from: input.index(input.startIndex, offsetBy: 1))))
    }
}