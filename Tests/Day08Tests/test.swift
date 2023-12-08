import Day08
import Utils
import XCTest

class Day08Tests: XCTestCase {
  func testParseLine() throws {
    let input = "AAA = (BBB, CCC)"
    let result = try parseLine(input)
    XCTAssertEqual("AAA", result.position)
    XCTAssertEqual("BBB", result.left)
    XCTAssertEqual("CCC", result.right)
  }

  func testParseInput() throws {
    let input = [
      "AAA = (BBB, CCC)",
      "BBB = (DDD, EEE)",
      "CCC = (ZZZ, GGG)",
      "DDD = (DDD, DDD)",
      "EEE = (EEE, EEE)",
      "GGG = (GGG, GGG)",
      "ZZZ = (ZZZ, ZZZ)",
    ]
    let result = try parseInput(input)
    XCTAssertEqual(7, result.count)
    XCTAssertEqual("DDD", result[3].position)
    XCTAssertEqual("BBB", result[0].leftNode?.position)
    XCTAssertEqual("CCC", result[0].rightNode?.position)
  }

  func testGivenInput11() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeNumberOfSteps(input)

    XCTAssertEqual(2, result)
  }

  func testGivenInput12() throws {
    let filePath = Bundle.module.url(forResource: "test-input12", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeNumberOfSteps(input)

    XCTAssertEqual(6, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeNumberOfSteps(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input2", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeNumberOfStepsGhost(input)

    XCTAssertEqual(6, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeNumberOfStepsGhost(input)

    print(result)
  }
}
