import Utils
import XCTest

@testable import Day11

class Day11Tests: XCTestCase {
  func testParseImage() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let image = parseImage(input)

    XCTAssertEqual(9, image.galaxies.count)
  }

  func testRowsToExpand() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let image = parseImage(input)

    XCTAssertEqual([3, 7], image.rowsToExpand)
  }

  func testColumnsToExpand() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let image = parseImage(input)

    XCTAssertEqual([2, 5, 8], image.columnsToExpand)
  }

  func testGivenInput1() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = computeSum(input)

    XCTAssertEqual(374, result)
  }

  func testUnknownInput1() {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = computeSum(input)

    print(result)
  }

  func testGivenInput21() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = computeSum(input, expansion: 10)

    XCTAssertEqual(1030, result)
  }

  func testGivenInput22() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = computeSum(input, expansion: 100)

    XCTAssertEqual(8410, result)
  }

  func testUnknownInput2() {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = computeSum(input, expansion: 1_000_000)

    print(result)
  }
}
