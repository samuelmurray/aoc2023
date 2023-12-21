import XCTest

@testable import Day17
@testable import Utils

class Day17Tests: XCTestCase {
  func testSuccessor() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)
    let map = parseMap(input)

    let state = AocState(
      position: Position(0, 0), direction: .right, steps: 0, minSteps: 0, maxSteps: 3, map: map)
    let result = state.successors()
    XCTAssertEqual([Position(1, 0), Position(0, 1)], result.map { $0.state.position })
    XCTAssertEqual([1, 1], result.map { $0.state.steps })
    XCTAssertEqual([.right, .down], result.map { $0.state.direction })
  }

  func testGivenInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try solve(input, minSteps: 0, maxSteps: 3)

    XCTAssertEqual(102, result)
  }

  func testUnknownInput1() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try solve(input, minSteps: 0, maxSteps: 3)

    print(result)
  }

  func testGivenInput21() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try solve(input, minSteps: 4, maxSteps: 10)

    XCTAssertEqual(94, result)
  }

  func testGivenInput22() throws {
    guard let filePath = Bundle.module.url(forResource: "test-input2", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try solve(input, minSteps: 4, maxSteps: 10)

    XCTAssertEqual(71, result)
  }

  func testUnknownInput2() throws {
    guard let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt") else {
      throw AocError.runtimeError("File not found")
    }
    let input = try readFile(filePath)

    let result = try solve(input, minSteps: 4, maxSteps: 10)

    print(result)
  }
}
