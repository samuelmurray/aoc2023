import Foundation
import Utils

public struct WinningNumber: RowObject, Hashable {
  public static var regexp = try! NSRegularExpression(pattern: "(\\d+)(?=([^:]*\\|))")

  public var row: Int

  public var startPosition: Int

  public var length: Int

  public let number: Int

  public init(row: Int, startPosition: Int, length: Int, content: String) throws {
    self.row = row
    self.startPosition = startPosition
    self.length = length
    guard let number = Int(content) else {
      throw AocError.runtimeError("Content not Int: \(content)")
    }
    self.number = number
  }
}

public struct DrawnNumber: RowObject, Hashable {
  public static var regexp = try! NSRegularExpression(pattern: "(\\d+)(?=([^\\|]*$))")

  public var row: Int

  public var startPosition: Int

  public var length: Int

  public let number: Int

  public init(row: Int, startPosition: Int, length: Int, content: String) throws {
    self.row = row
    self.startPosition = startPosition
    self.length = length
    guard let number = Int(content) else {
      throw AocError.runtimeError("Content not Int: \(content)")
    }
    self.number = number
  }
}

public func parseWinningNumbers(_ input: String) -> [WinningNumber] {
  return parseRowObjects(input: input, rowNumber: 0, type: WinningNumber.self)
}

public func parseDrawnNumbers(_ input: String) -> [DrawnNumber] {
  return parseRowObjects(input: input, rowNumber: 0, type: DrawnNumber.self)
}

public func computeSum1(_ input: [String]) -> Int {
  var sum = 0
  for (n, line) in input.enumerated() {
    let winningNumbers = parseRowObjects(input: line, rowNumber: n, type: WinningNumber.self)
    let drawnNumbers = parseRowObjects(input: line, rowNumber: n, type: DrawnNumber.self)
    let intersection = Set(winningNumbers.map { $0.number }).intersection(
      drawnNumbers.map { $0.number })
    if !intersection.isEmpty {
      let score = pow(2, intersection.count - 1)
      sum += NSDecimalNumber(decimal: score).intValue
    }
  }
  return sum
}

public func computeSum2(_ input: [String]) -> Int {
  var numberOfCopies = Array(repeating: 1, count: input.count)
  for (n, line) in input.enumerated() {
    let winningNumbers = parseRowObjects(input: line, rowNumber: n, type: WinningNumber.self)
    let drawnNumbers = parseRowObjects(input: line, rowNumber: n, type: DrawnNumber.self)
    let intersection = Set(winningNumbers.map { $0.number }).intersection(
      drawnNumbers.map { $0.number })
    if !intersection.isEmpty {
      for i in (n + 1..<min(n + 1 + intersection.count, input.count)) {
        numberOfCopies[i] += numberOfCopies[n]
      }
    }
  }
  return numberOfCopies.reduce(0, +)
}
