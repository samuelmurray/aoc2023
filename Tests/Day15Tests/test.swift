import Utils
import XCTest

@testable import Day15

class Day15Tests: XCTestCase {
  func testHash() {
    XCTAssertEqual(52, hash("HASH"))
    XCTAssertEqual(30, hash("rn=1"))
    XCTAssertEqual(231, hash("ot=7"))
  }

  func testGivenInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeSum1(input)

    XCTAssertEqual(1320, result)
  }

  func testUnknownInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeSum1(input)

    print(result)
  }

  func testGivenInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeSum2(input)

    XCTAssertEqual(145, result)
  }

func testUnknownInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try computeSum2(input)

    print(result)
  }
}
