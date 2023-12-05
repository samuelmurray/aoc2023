import Foundation
import Utils

public struct SeedRange: RowObject {
  public static var regexp = try! NSRegularExpression(pattern: "(\\d+ \\d+)")

  var start: Int
  var range: Int

  public init(content: String) throws {
    let numbers = content.split(separator: " ")
    guard let start = Int(numbers[0]) else {
      throw AocError.runtimeError("Bad input \(content)")
    }
    guard let range = Int(numbers[1]) else {
      throw AocError.runtimeError("Bad input \(content)")
    }
    self.start = start
    self.range = range
  }
}

public struct Seed: RowObject {
  public static var regexp = try! NSRegularExpression(pattern: "(\\d+)")

  public var id: Int

  public init(content: String) throws {
    guard let id = Int(content) else {
      throw AocError.runtimeError("Content not Int: \(content)")
    }
    self.id = id
  }

  public init(id: Int) {
    self.id = id
  }
}

public struct AlmanacMapRange {
  public static var regexp = try! NSRegularExpression(pattern: "(\\d+)")
  let source: Int
  let destination: Int
  let length: Int

  public init(source: Int, destination: Int, length: Int) {
    self.source = source
    self.destination = destination
    self.length = length
  }

  public static func parse(line: String) -> AlmanacMapRange {
    let content = try! line.split(separator: " ").map {
      guard let a = Int($0) else {
        throw AocError.runtimeError("Bad input: \(line)")
      }
      return a
    }
    return AlmanacMapRange(source: content[1], destination: content[0], length: content[2])
  }
}

public struct AlmanacMap {
  let ranges: [AlmanacMapRange]

  public init(_ ranges: [AlmanacMapRange]) {
    self.ranges = ranges
  }
}

extension AlmanacMap {
  public func getDestination(ofSource: Int) -> Int {
    for range in ranges {
      let diff = ofSource - range.source
      if diff >= 0 && diff < range.length {
        return range.destination + diff
      }
    }
    return ofSource
  }

  public func getSource(ofDestination: Int) -> Int {
    for range in ranges {
      let diff = ofDestination - range.destination
      if diff >= 0 && diff < range.length {
        return range.source + diff
      }
    }
    return ofDestination
  }
}

public func parseInput(_ input: [String]) -> ([Seed], [AlmanacMap]) {
  let firstLine = input.first!
  let seeds = parseRowObjects(input: firstLine, type: Seed.self)
  let maps = parseMaps(input)
  return (seeds, maps)
}

func parseInputWithSeedRanges(_ input: [String]) -> ([SeedRange], [AlmanacMap]) {
  let firstLine = input.first!
  let seeds = parseRowObjects(input: firstLine, type: SeedRange.self)
  let maps = parseMaps(input)
  return (seeds, maps)
}

func parseMaps(_ input: [String]) -> [AlmanacMap] {
  var maps: [AlmanacMap] = []
  var creatingMap = false
  var ranges: [AlmanacMapRange] = []
  for (n, line) in input.enumerated() where n > 0 {
    if line.isEmpty {
      if creatingMap {
        maps.append(AlmanacMap(ranges))
        creatingMap = false
        ranges = []
      }
      continue
    }
    if line.first?.isLetter ?? true {
      creatingMap = true
    } else {
      ranges.append(AlmanacMapRange.parse(line: line))
    }
  }
  if creatingMap {
    maps.append(AlmanacMap(ranges))
  }
  return maps
}

func computeLocation(_ seed: Seed, _ maps: [AlmanacMap]) -> Int {
  var currentId = seed.id
  for map in maps {
    currentId = map.getDestination(ofSource: currentId)
  }
  return currentId
}

func computeLowestLocation(_ seedRange: SeedRange, _ maps: [AlmanacMap]) -> Int {
  (seedRange.start..<seedRange.start + seedRange.range).map { id in
    var currentId = id
    for map in maps {
      currentId = map.getDestination(ofSource: currentId)
    }
    return currentId
  }.min() ?? -1
}

public func computeThresholdSources(
  _ map: AlmanacMap,
  _ thresholdDestinations: Set<Int>
) -> Set<Int> {
  let thresholdSources = Set(thresholdDestinations.map { map.getSource(ofDestination: $0) })
  let newThresholds =
    map.ranges.flatMap {
      [0, $0.source - 1, $0.source, $0.source + $0.length - 1, $0.source + $0.length]
    }
  return thresholdSources.union(newThresholds)
}

public func computeLowestLocation1(_ input: [String]) -> Int {
  let (seeds, maps) = parseInput(input)
  return seeds.map { computeLocation($0, maps) }.min() ?? -1
}

public func computeLowestLocation2(_ input: [String]) -> Int {
  let (seedRanges, maps) = parseInputWithSeedRanges(input)
  var thresholds = Set<Int>()
  for map in maps.reversed() {
    thresholds = computeThresholdSources(map, thresholds)
  }
  let locations = thresholds.filter { source in
    isValidSource(source, seedRanges)
  }.map { source in
    let location = computeLocation(Seed(id: source), maps)
    //print("Source: \(source) - destination: \(location)")
    return location
  }
  return locations.min()!
}

public func computeLowestLocation2_slow(_ input: [String]) -> Int {
  let (seedRanges, maps) = parseInputWithSeedRanges(input)
  for i in (15_880_234..<99_999_999) { // "answer - 2" inserted
    var destination = i
    for map in maps.reversed() {
      destination = map.getSource(ofDestination: destination)
    }
    if isValidSource(destination, seedRanges) {
      return i
    }
  }
  return -1
}

func isValidSource(_ source: Int, _ ranges: [SeedRange]) -> Bool {
  ranges.contains { source >= $0.start && source < $0.start + $0.range }
}