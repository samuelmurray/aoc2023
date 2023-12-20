import Foundation
import Utils
import XCTest

@testable import Day13

class Day13Tests: XCTestCase {
  func testFindReflectionLine1() {
    let input = [
      "#.##..##.",
      "..#.##.#.",
      "##......#",
      "##......#",
      "..#.##.#.",
      "..##..##.",
      "#.#.##.#.",
    ]

    let result = findReflectionLine(input)

    XCTAssertNil(result)
  }

  func testFindReflectionLine2() {
    let input = [
      "#...##..#",
      "#....#..#",
      "..##..###",
      "#####.##.",
      "#####.##.",
      "..##..###",
      "#....#..#",
    ]

    let result = findReflectionLine(input)

    XCTAssertEqual(4, result)
  }

  func testTransposeAndFindReflection() {
    let input = [
      "#.##..##.",
      "..#.##.#.",
      "##......#",
      "##......#",
      "..#.##.#.",
      "..##..##.",
      "#.#.##.#.",
    ]

    let transposedInput = input.transposed()

    let result = findReflectionLine(transposedInput)

    XCTAssertEqual(5, result)
  }

  func testDistance() {
    let a = "#..#"
    let b = "...#"

    let distance = levDist(a, b)

    XCTAssertEqual(1, distance)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum(input)

    XCTAssertEqual(405, result)
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

    let result = computeSum(input, numSmudges: 1)

    XCTAssertEqual(400, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeSum(input, numSmudges: 1)

    print(result)
  }
}
