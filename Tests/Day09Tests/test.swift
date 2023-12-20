import Utils
import XCTest

@testable import Day09

class Day09Tests: XCTestCase {
  func testDeltas() {
    let values = [0, 3, 6, 9, 12, 15]
    let deltas = values.deltas()
    XCTAssertEqual([3, 3, 3, 3, 3], deltas)
  }

  func testPredictNext() {
    let values = [0, 3, 6, 9, 12, 15]
    let next = values.predictNext()
    XCTAssertEqual(18, next)
  }

  func testPredictNext2() {
    let values = [1, 3, 6, 10, 15, 21]
    let next = values.predictNext()
    XCTAssertEqual(28, next)
  }

  func testPredictPrevious() {
    let values = [10, 13, 16, 21, 30, 45]
    let previous = values.predictPrevious()
    XCTAssertEqual(5, previous)
  }

  func testPredictNextForHistory() {
    let history = OasisHistory(values: [0, 3, 6, 9, 12, 15])
    let next = history.predictNext()
    XCTAssertEqual(18, next)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum1(input)

    XCTAssertEqual(114, result)
  }

  func testUknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum1(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    XCTAssertEqual(2, result)
  }

  func testUknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum2(input)

    print(result)
  }
}
