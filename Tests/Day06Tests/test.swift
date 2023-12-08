import Day06
import Utils
import XCTest

class Day06Tests: XCTestCase {
  func testComputeDistances() {
    let race = Race(Time(7), Distance(9))

    let result = computeDistances(race)

    XCTAssertEqual([0, 6, 10, 12, 12, 10, 6, 0], result.map { $0.distanceMm })
  }

  func testComputeNumberOfWinningWindupTimes() {
    let race = Race(Time(7), Distance(9))

    let result = computeNumberOfWinningWindupTimes(race)

    XCTAssertEqual(4, result)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeProduct(input)

    XCTAssertEqual(288, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeProduct(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)
    let trimmedInput = input.map {$0.replacingOccurrences(of: "\\s", with: "", options: [.regularExpression])}

    let result = try computeProduct(trimmedInput)

    XCTAssertEqual(71503, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)
    let trimmedInput = input.map {$0.replacingOccurrences(of: "\\s", with: "", options: [.regularExpression])}

    let result = try computeProduct(trimmedInput)

    print(result)
  }
}
