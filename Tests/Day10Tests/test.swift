import Utils
import XCTest

@testable import Day10

class Day10Tests: XCTestCase {
  func testDimensions() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual(6, map.dimensions.0)
    XCTAssertEqual(5, map.dimensions.1)
  }

  func testSubscript() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual(Tile(type: .ground), map[0, 0])
    XCTAssertEqual(Tile(type: .se), map[1, 1])
    XCTAssertEqual(Tile(type: .sw), map[3, 1])
  }

  func testSubscriptOutsideMap() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertNil(map[-1, 0])
  }

  func testNeighboursOfGround() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual([], try map.neighbours(of: (0, 0)))
  }

  func testNeightbourdsOutsideMapThrows() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertThrowsError(try map.neighbours(of: (-1, 0)))
  }

  func testNeighboursOfNE() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual([Position(1, 2), Position(2, 3)], try map.neighbours(of: (1, 3)))
  }

  func testNeighboursOfNS() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual([Position(1, 1), Position(1, 3)], try map.neighbours(of: (1, 2)))
  }

  func testStartPositionOfMapWithoutS() throws {
    let filePath = Bundle.module.url(forResource: "test-input11", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertNil(map.startPosition)
  }

  func testStartPositionOfMapWithS() throws {
    let filePath = Bundle.module.url(forResource: "test-input12", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual(Position(0, 2), map.startPosition)
  }

  func testNeighboursOfStart() throws {
    let filePath = Bundle.module.url(forResource: "test-input12", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual([Position(1, 2), Position(0, 3)], try map.neighbours(of: (0, 2)))
  }

  func testLoop() throws {
    let filePath = Bundle.module.url(forResource: "test-input12", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)

    XCTAssertEqual(16, try map.loop(from: Position(0, 2)).count)
  }

  func testIsInside() throws {
    let filePath = Bundle.module.url(forResource: "test-input21", withExtension: "txt")!
    let input = try readFile(filePath)

    let map = parseMap(input)
    let start = map.startPosition!
    let loop = try map.loop(from: start)

    XCTAssertFalse(try isInside(Position(3, 3), map, loop))
    XCTAssertTrue(try isInside(Position(2, 6), map, loop))
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input12", withExtension: "txt")!
    let input = try readFile(filePath)

    XCTAssertEqual(8, try computeFarthestPosition(input))
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = try computeFarthestPosition(input)

    print(result)
  }

  func testGivenInput21() throws {
    let filePath = Bundle.module.url(forResource: "test-input21", withExtension: "txt")!
    let input = try readFile(filePath)

    XCTAssertEqual(4, try computeEnclosedRegion(input))
  }

  func testGivenInput22() throws {
    let filePath = Bundle.module.url(forResource: "test-input22", withExtension: "txt")!
    let input = try readFile(filePath)

    XCTAssertEqual(8, try computeEnclosedRegion(input))
  }

  func testGivenInput23() throws {
    let filePath = Bundle.module.url(forResource: "test-input23", withExtension: "txt")!
    let input = try readFile(filePath)

    XCTAssertEqual(10, try computeEnclosedRegion(input))
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = try computeEnclosedRegion(input)

    print(result)
  }
}
