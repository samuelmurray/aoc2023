import Day04
import Foundation
import Utils
import XCTest

class Day04Tests: XCTestCase {
  func testParseWinningNumbers() {
    let input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    let winningNumbers = parseWinningNumbers(input)

    XCTAssertEqual(5, winningNumbers.count)
    XCTAssertEqual([41, 48, 83, 86, 17], winningNumbers.map { $0.number })
  }

  func testParseDrawnNumbers() {
    let input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    let drawnNumbers = parseDrawnNumbers(input)

    XCTAssertEqual(8, drawnNumbers.count)
    XCTAssertEqual([83, 86, 6, 31, 17, 9, 48, 53], drawnNumbers.map { $0.number })
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum1(input)

    XCTAssertEqual(13, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum1(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    XCTAssertEqual(30, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    print(result)
  }
}
