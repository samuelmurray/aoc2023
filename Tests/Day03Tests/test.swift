import Day03
import Foundation
import Utils
import XCTest

class Day03Tests: XCTestCase {
  func testParseRowSingleNumber() {
    let input = "..467"
    let (partNumbers, _) = parseRow(input: input, rowNumber: 6)

    XCTAssertEqual(1, partNumbers.count)

    XCTAssertEqual(467, partNumbers[0].number)
    XCTAssertEqual(2, partNumbers[0].startPosition)
    XCTAssertEqual(3, partNumbers[0].length)
    XCTAssertEqual(6, partNumbers[0].row)
  }

  func testParseRowMultipleNumbers() {
    let input = "467..114.."
    let (partNumbers, _) = parseRow(input: input, rowNumber: 0)

    XCTAssertEqual(2, partNumbers.count)

    XCTAssertEqual(467, partNumbers[0].number)
    XCTAssertEqual(0, partNumbers[0].startPosition)
    XCTAssertEqual(3, partNumbers[0].length)
    XCTAssertEqual(0, partNumbers[0].row)

    XCTAssertEqual(114, partNumbers[1].number)
    XCTAssertEqual(5, partNumbers[1].startPosition)
    XCTAssertEqual(3, partNumbers[1].length)
    XCTAssertEqual(0, partNumbers[1].row)
  }

  func testParseSymbols() {
    let input = "...$.*...."
    let (_, symbols) = parseRow(input: input, rowNumber: 3)

    XCTAssertEqual(2, symbols.count)

    XCTAssertEqual(3, symbols[0].column)
    XCTAssertEqual(3, symbols[0].row)
    XCTAssertEqual("$", symbols[0].symbol)

    XCTAssertEqual(5, symbols[1].column)
    XCTAssertEqual(3, symbols[1].row)
    XCTAssertEqual("*", symbols[1].symbol)
  }

  func testAdjacency_NumberBeforeSymbol() {
    let input = "467*"
    let (partNumbers, symbols) = parseRow(input: input, rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(1, result.count)
  }

  func testAdjacency_NumberAfterSymbol() {
    let input = "*467"
    let (partNumbers, symbols) = parseRow(input: input, rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(1, result.count)
  }

  func testAdjacency_NumberOnSameRowNotAdjacent() {
    let input = "467.*"
    let (partNumbers, symbols) = parseRow(input: input, rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(0, result.count)
  }

  func testAdjacency_SymbolBelowNumber() {
    let (partNumbers, _) = parseRow(input: "467", rowNumber: 0)
    let (_, symbols) = parseRow(input: ".*.", rowNumber: 1)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(1, result.count)
  }

  func testAdjacency_SymbolDiagonallyBelowNumber() {
    let (partNumbers, _) = parseRow(input: ".67.87.", rowNumber: 0)
    let (_, symbols) = parseRow(input: "*.....*", rowNumber: 1)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(2, result.count)
  }

  func testAdjacency_SymbolBelowNumberButNotAdjacent() {
    let (partNumbers, _) = parseRow(input: "..7..", rowNumber: 0)
    let (_, symbols) = parseRow(input: "*...*", rowNumber: 1)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(0, result.count)
  }

  func testAdjacency_SymbolAboveNumber() {
    let (partNumbers, _) = parseRow(input: "467", rowNumber: 1)
    let (_, symbols) = parseRow(input: ".*.", rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(1, result.count)
  }

  func testAdjacency_SymbolDiagonallyAboveNumber() {
    let (partNumbers, _) = parseRow(input: ".67.87.", rowNumber: 1)
    let (_, symbols) = parseRow(input: "*.....*", rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(2, result.count)
  }

  func testAdjacency_SymbolAboveNumberButNotAdjacent() {
    let (partNumbers, _) = parseRow(input: "..7..", rowNumber: 1)
    let (_, symbols) = parseRow(input: "*...*", rowNumber: 0)

    let result = partNumbersWithAdjacentSymbols(partNumbers, symbols)

    XCTAssertEqual(0, result.count)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum(input)

    XCTAssertEqual(4361, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    XCTAssertEqual(467835, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    print(result)
  }
}
