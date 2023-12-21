import Utils
import XCTest

@testable import Day18

class Day18Tests: XCTestCase {
  func testTrenchEdgeSize() throws {
    let input = [
      "R 6 (#70c710)",
      "D 5 (#0dc571)",
      "L 2 (#5713f0)",
      "D 2 (#d2c081)",
      "R 2 (#59c680)",
      "D 2 (#411b91)",
      "L 5 (#8ceee2)",
      "U 2 (#caa173)",
      "L 1 (#1b58a2)",
      "U 2 (#caa171)",
      "R 2 (#7807d2)",
      "U 3 (#a77fa3)",
      "L 2 (#015232)",
      "U 2 (#7a21e3)",
    ]
    let trench = try parseTrench(input)

    XCTAssertEqual(38, trench.edge.count)
  }

  func testGivenInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeArea(input)

    XCTAssertEqual(62, result)
  }

  func testUnknownInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeArea(input)

    print(result)  // 62500
  }
}
