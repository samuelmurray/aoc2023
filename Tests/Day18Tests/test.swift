import Utils
import XCTest

@testable import Day18

class Day18Tests: XCTestCase {
  func testShoelace1() throws {
    let input = [
      "R 2",
      "D 1",
      "L 2",
      "U 1",
    ]
    let result = try computeArea(input)

    XCTAssertEqual(6, result)
  }

  func testShoelace2() throws {
    let input = [
      "R 1",
      "U 1",
      "R 1",
      "D 2",
      "L 2",
      "U 1",
    ]
    let result = try computeArea(input)

    XCTAssertEqual(8, result)
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

    print(result)
  }

  func testGivenInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeAreaHex(input)

    XCTAssertEqual(952408144115, result)
  }

  func testUnknownInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeAreaHex(input)

    print(result)
  }
}
