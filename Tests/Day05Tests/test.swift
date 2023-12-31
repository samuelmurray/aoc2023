import Day05
import Utils
import XCTest

class Day05Tests: XCTestCase {
  func testIdentity() {
    let map = AlmanacMap([])
    let result = map.getDestination(ofSource: 1)
    XCTAssertEqual(1, result)
  }

  func testRangeValue() {
    let range = AlmanacMapRange(source: 98, destination: 50, length: 2)
    let map = AlmanacMap([range])
    let result = map.getDestination(ofSource: 99)
    XCTAssertEqual(51, result)
  }

  func testRangeValueAboveLength() {
    let range = AlmanacMapRange(source: 98, destination: 50, length: 2)
    let map = AlmanacMap([range])
    let result = map.getDestination(ofSource: 100)
    XCTAssertEqual(100, result)
  }

  func testRangeValueBelowLength() {
    let range = AlmanacMapRange(source: 98, destination: 50, length: 2)
    let map = AlmanacMap([range])
    let result = map.getDestination(ofSource: 97)
    XCTAssertEqual(97, result)
  }

  func testMultipleRanges() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    XCTAssertEqual(0, map.getDestination(ofSource: 0))
    XCTAssertEqual(49, map.getDestination(ofSource: 49))
    XCTAssertEqual(52, map.getDestination(ofSource: 50))
    XCTAssertEqual(99, map.getDestination(ofSource: 97))
    XCTAssertEqual(50, map.getDestination(ofSource: 98))
    XCTAssertEqual(51, map.getDestination(ofSource: 99))
    XCTAssertEqual(100, map.getDestination(ofSource: 100))
  }

  func testGetSource() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    XCTAssertEqual(0, map.getSource(ofDestination: 0))
    XCTAssertEqual(49, map.getSource(ofDestination: 49))
    XCTAssertEqual(50, map.getSource(ofDestination: 52))
    XCTAssertEqual(97, map.getSource(ofDestination: 99))
    XCTAssertEqual(98, map.getSource(ofDestination: 50))
    XCTAssertEqual(99, map.getSource(ofDestination: 51))
    XCTAssertEqual(100, map.getSource(ofDestination: 100))

  }

  func testParseSeeds() {
    let input = "seeds: 79 14 55 13"
    let (seeds, _) = parseInput([input])
    XCTAssertEqual([79, 14, 55, 13], seeds.map { $0.id })
  }

  func testParseMap() {
    let (seeds, maps) = parseInput([
      "seeds: 79 14 55 13",
      "",
      "seed-to-soil map:",
      "50 98 2",
      "52 50 48",
    ])
    XCTAssertEqual([79, 14, 55, 13], seeds.map { $0.id })
    XCTAssertEqual(1, maps.count)
    XCTAssertEqual(52, maps[0].getDestination(ofSource: 50))
  }

  func testParseMultipleMaps() {
    let (_, maps) = parseInput([
      "seeds: 79 14 55 13",
      "",
      "seed-to-soil map:",
      "50 98 2",
      "52 50 48",
      "",
      "soil-to-fertilizer map:",
      "0 15 37",
      "37 52 2",
      "39 0 15",
      "",
      "fertilizer-to-water map:",
      "49 53 8",
      "0 11 42",
      "42 0 7",
      "57 7 4",
    ])
    XCTAssertEqual(3, maps.count)
    XCTAssertEqual(0, maps[2].getDestination(ofSource: 11))
  }

  func testComputeThresholdValues() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    let values = computeThresholdSources(map, Set())
    XCTAssertEqual([0, 49, 50, 97, 98, 99, 100], values)
  }

  func testFlattenMapsSingleMap() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    let result = flattenMaps([map])
    XCTAssertEqual(map, result)
  }

  func testFlattenMapsFirstEmptyMap() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    let result = flattenMaps([AlmanacMap([]), map])
    XCTAssertEqual(map, result)
  }

  func testFlattenMapsSecondEmptyMap() {
    let map = AlmanacMap([
      AlmanacMapRange(source: 98, destination: 50, length: 2),
      AlmanacMapRange(source: 50, destination: 52, length: 48),
    ])
    let result = flattenMaps([map, AlmanacMap([])])
    XCTAssertEqual(map, result)
  }

  func testFlattenMapsTwoLayers() {
    let map1 = AlmanacMap([
      AlmanacMapRange(source: 1, destination: 2, length: 1),
      AlmanacMapRange(source: 2, destination: 1, length: 1),
    ])
    let map2 = AlmanacMap([
      AlmanacMapRange(source: 51, destination: 52, length: 1),
      AlmanacMapRange(source: 52, destination: 51, length: 1),
    ])
    let expected = AlmanacMap([
      AlmanacMapRange(source: 1, destination: 2, length: 1),
      AlmanacMapRange(source: 2, destination: 1, length: 1),
      AlmanacMapRange(source: 51, destination: 52, length: 1),
      AlmanacMapRange(source: 52, destination: 51, length: 1),
    ])
    let result = flattenMaps([map1, map2])
    XCTAssertEqual(expected, result)
  }

  func testFlattenMapsTwoLayersAdvanced() {
    let map1 = AlmanacMap([
      AlmanacMapRange(source: 10, destination: 20, length: 10)
    ])
    let map2 = AlmanacMap([
      AlmanacMapRange(source: 20, destination: 30, length: 5)
    ])
    let expected = AlmanacMap([
      AlmanacMapRange(source: 10, destination: 30, length: 5),
      AlmanacMapRange(source: 15, destination: 25, length: 5),
    ])
    let result = flattenMaps(map1, map2)
    XCTAssertEqual(expected, result)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeLowestLocation1(input)

    XCTAssertEqual(35, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeLowestLocation1(input)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeLowestLocationByFlatten(input)

    XCTAssertEqual(46, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeLowestLocationByFlatten(input)

    print(result)
  }
}
