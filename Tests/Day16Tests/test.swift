import Utils
import XCTest

@testable import Day16

class Day16Tests: XCTestCase {
  func testAdvanceSimple() {
    let map = parseMap([".|...\\...."])
    let result = map.advance(BeamFront(position: Position(0, 0), direction: .right))
    XCTAssertEqual(1, result.count)
    XCTAssertEqual(Position(1, 0), result[0].position)
    XCTAssertEqual(.right, result[0].direction)
  }

  func testAdvanceOutOfMap() {
    let map = parseMap([".|...\\...."])
    let result = map.advance(BeamFront(position: Position(0, 0), direction: .down))
    XCTAssertEqual(0, result.count)
  }

  func testGivenInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = compute1(input)

    XCTAssertEqual(46, result)
  }

  func testUnknownInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = compute1(input)

    print(result)
  }

  func testGivenInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = compute2(input)

    XCTAssertEqual(51, result)
  }

  func testUnknownInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = compute2(input)

    print(result)
  }
}
