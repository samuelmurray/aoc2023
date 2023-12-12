import Utils
import XCTest

@testable import Day12

class Day12Tests: XCTestCase {
  func testIsCompatible_DamagedAndDamaged() {
    let damaged1 = ConditionRecord(springs: [.damaged])
    let damaged2 = ConditionRecord(springs: [.damaged])

    XCTAssert(try damaged1.isCompatible(with: damaged2))
    XCTAssert(try damaged2.isCompatible(with: damaged1))
  }

  func testIsCompatible_OperationalAndOperational() {
    let operational1 = ConditionRecord(springs: [.operational])
    let operational2 = ConditionRecord(springs: [.operational])

    XCTAssert(try operational1.isCompatible(with: operational2))
    XCTAssert(try operational2.isCompatible(with: operational1))
  }

  func testIsCompatible_DamagedAndOperational() {
    let damaged = ConditionRecord(springs: [.damaged])
    let operational = ConditionRecord(springs: [.operational])

    XCTAssertFalse(try damaged.isCompatible(with: operational))
    XCTAssertFalse(try operational.isCompatible(with: damaged))
  }

  func testIsCompatible_UnknownAndDamaged() {
    let unknown = ConditionRecord(springs: [.unknown])
    let damaged = ConditionRecord(springs: [.damaged])

    XCTAssert(try unknown.isCompatible(with: damaged))
    XCTAssert(try damaged.isCompatible(with: unknown))
  }

  func testIsCompatible_UnknownAndOperational() {
    let unknown = ConditionRecord(springs: [.unknown])
    let operational = ConditionRecord(springs: [.operational])

    XCTAssert(try unknown.isCompatible(with: operational))
    XCTAssert(try operational.isCompatible(with: unknown))
  }

  func testIsCompatible_ArraysOfDifferentLength() {
    let first = ConditionRecord(springs: [.operational, .operational])
    let second = ConditionRecord(springs: [.operational])

    XCTAssertThrowsError(try first.isCompatible(with: second))
    XCTAssertThrowsError(try second.isCompatible(with: first))
  }

  func testIsCompatible_ArraysOfCompatible() {
    let unknown = ConditionRecord(springs: [.operational, .unknown])
    let known = ConditionRecord(springs: [.operational, .damaged])

    XCTAssert(try unknown.isCompatible(with: known))
    XCTAssert(try known.isCompatible(with: unknown))
  }

  func testIsCompatible_ArraysOfIncompatible() {
    let unknown = ConditionRecord(springs: [.operational, .operational])
    let known = ConditionRecord(springs: [.operational, .damaged])

    XCTAssertFalse(try unknown.isCompatible(with: known))
    XCTAssertFalse(try known.isCompatible(with: unknown))
  }

  func testGenerateTrivial() throws {
    let result = try generatePossibleRecords(ConditionRecord(springs: [.unknown]), [1])

    XCTAssertEqual([ConditionRecord(springs: [.damaged])], result)
  }

  func testGenerateSimple() throws {
    let result = try generatePossibleRecords(
      ConditionRecord(springs: [.unknown].repeated(count: 2)), [1])

    XCTAssertEqual(
      [
        ConditionRecord(springs: [.damaged, .operational]),
        ConditionRecord(springs: [.operational, .damaged]),
      ], result)
  }

  func testGenerateThrows() throws {
    XCTAssertThrowsError(
      try generatePossibleRecords(ConditionRecord(springs: [.unknown].repeated(count: 2)), [1, 1]))
  }

  func testGenerateTwoParts() throws {
    let result = try generatePossibleRecords(
      ConditionRecord(springs: [.unknown].repeated(count: 3)), [1, 1])

    XCTAssertEqual([ConditionRecord(springs: [.damaged, .operational, .damaged])], result)
  }

  func testGenerateAdvanced() throws {
    let result = try generatePossibleRecords(
      ConditionRecord(springs: [.unknown].repeated(count: 7)), [1, 1, 2])

    XCTAssertEqual(
      Set([
        ConditionRecord(springs: [
          .damaged, .operational, .damaged, .operational, .damaged, .damaged, .operational,
        ]),
        ConditionRecord(springs: [
          .damaged, .operational, .damaged, .operational, .operational, .damaged, .damaged,
        ]),
        ConditionRecord(springs: [
          .damaged, .operational, .operational, .damaged, .operational, .damaged, .damaged,
        ]),
        ConditionRecord(springs: [
          .operational, .damaged, .operational, .damaged, .operational, .damaged, .damaged,
        ]),
      ]), Set(result))
  }

  func testCountValidCombinations() {
    let reference = ConditionRecord(springs: [
      .unknown,
      .damaged, .damaged, .damaged,
      .unknown, .unknown, .unknown, .unknown, .unknown, .unknown, .unknown, .unknown,
    ])

    XCTAssertEqual(10, try countValidCombinations(reference, [3, 2, 1]))
  }

  func testRepetitions() throws {
    let result = try computeSum(["???.### 1,1,3"], duplications: 5)

    XCTAssertEqual(1, result)
  }

  func testRepetitionsMedium() throws {
    let result = try computeSum(["????.#...#... 4,1,1"], duplications: 5)

    XCTAssertEqual(16, result)
  }

  func testRepetitionsLarge() throws {
    let result = try computeSum(["????.######..#####. 1,6,5"], duplications: 5)

    XCTAssertEqual(2500, result)
  }

  func testRepetitionsHuge() throws {
    let result = try computeSum(["?###???????? 3,2,1"], duplications: 5)

    XCTAssertEqual(506250, result)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeSum(input)

    XCTAssertEqual(21, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeSum(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeSum(input, duplications: 5)

    XCTAssertEqual(525152, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)

    let result = try computeSum(Array(input[0..<2]), duplications: 5)

    print(result)
  }
}
