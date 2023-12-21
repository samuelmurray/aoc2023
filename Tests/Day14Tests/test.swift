import Utils
import XCTest

@testable import Day14

class Day14Tests: XCTestCase {
  func testRollWest() {
    let input = "OO.O.O..##"
    let result = rollWest(input)
    XCTAssertEqual("OOOO....##", result)
  }

  func testSpinCycle() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)
    print(spinCycle(input).joined(separator: "\n"))
  }

  func testGivenInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = computeSum(input)

    XCTAssertEqual(136, result)
  }

  func testUnknownInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = computeSum(input)

    print(result)
  }

  func testGivenInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = computeSum(input, numCycles: 1_000_000_000)

    XCTAssertEqual(64, result)
  }

  func testUnknownInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = computeSum(input, numCycles: 1_000_000_000)

    print(result)
  }
}
