import Foundation
import Utils

public struct PartNumber: RowObject {
  public static let regexp = try! NSRegularExpression(pattern: "(\\d+)")
  public let number: Int
  public let startPosition: Int
  public var endPosition: Int { startPosition + length - 1 }
  public let length: Int
  public let row: Int

  public init(row: Int, startPosition: Int, length: Int, content: String) throws {
    guard let number = Int(content) else {
      throw AocError.runtimeError("Content not number: \(content)")
    }
    self.number = number
    self.startPosition = startPosition
    self.length = length
    self.row = row
  }
}

public struct Symbol: RowObject {
  public static let regexp = try! NSRegularExpression(pattern: "([^.A-Z0-9])")
  public let symbol: Character
  public let column: Int
  public let length = 1
  public let row: Int
  public var startPosition: Int { column }
  public var endPosition: Int { column }

  public init(row: Int, startPosition: Int, length: Int, content: String) throws {
    if length != 1 {
      throw AocError.runtimeError("Unexpected length \(length)")
    }
    guard let symbol = content.first else {
      throw AocError.runtimeError("Content not character: \(content)")
    }
    self.symbol = symbol
    self.column = startPosition
    self.row = row
  }
}

public struct Gear {
  public let ratio: Int
}

public func parseRow(input: String, rowNumber: Int) -> (
  partNumbers: [PartNumber], symbols: [Symbol]
) {
  let partNumbers = parseRowObjects(input: input, rowNumber: rowNumber, type: PartNumber.self)

  let symbols = parseRowObjects(input: input, rowNumber: rowNumber, type: Symbol.self)

  return (partNumbers, symbols)
}

public func partNumbersWithAdjacentSymbols(_ partNumbers: [PartNumber], _ symbols: [Symbol])
  -> [PartNumber]
{
  var ret: [PartNumber] = []
  for partNumber in partNumbers {
    let symbolsAdjacent = symbols.filter { $0.adjacent(other: partNumber) }
    if !symbolsAdjacent.isEmpty {
      ret.append(partNumber)
      continue
    }
  }
  return ret
}

public func computeSum(_ input: [String]) -> Int {
  var partNumbers: [PartNumber] = []
  var symbols: [Symbol] = []
  for (n, line) in input.enumerated() {
    let (numbs, symbs) = parseRow(input: line, rowNumber: n)
    partNumbers.append(contentsOf: numbs)
    symbols.append(contentsOf: symbs)
  }
  let verifiedPartNumbers = partNumbersWithAdjacentSymbols(partNumbers, symbols)
  return verifiedPartNumbers.reduce(0, { x, y in x + y.number })
}

public func gears(_ partNumbers: [PartNumber], _ symbols: [Symbol]) -> [Gear] {
  var ret: [Gear] = []
  for symbol in symbols {
    if symbol.symbol != "*" {
      continue
    }
    let partNumbersAdjacent = partNumbers.filter { $0.adjacent(other: symbol) }
    if partNumbersAdjacent.count == 2 {
      ret.append(Gear(ratio: partNumbersAdjacent.reduce(1, { x, y in x * y.number })))
      continue
    }
  }
  return ret
}

public func computeSum2(_ input: [String]) -> Int {
  var partNumbers: [PartNumber] = []
  var symbols: [Symbol] = []
  for (n, line) in input.enumerated() {
    let (numbs, symbs) = parseRow(input: line, rowNumber: n)
    partNumbers.append(contentsOf: numbs)
    symbols.append(contentsOf: symbs)
  }
  let gears = gears(partNumbers, symbols)
  return gears.reduce(0, { x, y in x + y.ratio })
}
