import Day02
import Utils
import XCTest

class Day02Tests: XCTestCase {
  func testParsesIdCorrect() {
    let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    let (id, _) = parseGame(input)
    XCTAssertEqual(1, id)
  }

  func testParsesSubsetsCorrect() {
    let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    let (_, subsets) = parseGame(input)
    XCTAssertEqual(3, subsets.count)
    XCTAssertEqual(Subset(reds: 4, greens: 0, blues: 3), subsets[0])
    XCTAssertEqual(Subset(reds: 1, greens: 2, blues: 6), subsets[1])
    XCTAssertEqual(Subset(reds: 0, greens: 2, blues: 0), subsets[2])
  }

  func testIsPossible() {
    let a = Subset(reds: 0, greens: 4, blues: 5)
    let b = Subset(reds: 0, greens: 3, blues: 4)
    XCTAssert(a.isGreaterThan(b))
    XCTAssertFalse(b.isGreaterThan(a))
  }

  func testSmallInput() {
    let result = computeSum(
      ["Game 2: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"],
      Subset(reds: 12, greens: 13, blues: 14))
    XCTAssertEqual(2, result)
  }

  func testSmallInputFalse() {
    let result = computeSum(
      ["Game 2: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"],
      Subset(reds: 5, greens: 5, blues: 5))
    XCTAssertEqual(0, result)
  }

  func testErroneousInput() {
    let (_, subsets) = parseGame(
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red")
    print(subsets)
    let bag = Subset(reds: 12, greens: 13, blues: 14)
    XCTAssertFalse(isPossible(subsets, bag))
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    XCTAssertEqual(8, computeSum(input, Subset(reds: 12, greens: 13, blues: 14)))
  }

  func testInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)
    let sum = computeSum(input, Subset(reds: 12, greens: 13, blues: 14))
    print(sum)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)
    XCTAssertEqual(2286, computeSumOfSmallestBags(input))
  }

  func testInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)
    let sum = computeSumOfSmallestBags(input)
    print(sum)
  }
}
