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

public struct AlmanacMapRange: Equatable {
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

extension AlmanacMapRange {
  var sourceEnd: Int { source + length }
}

public struct AlmanacMap: Equatable {
  let ranges: [AlmanacMapRange]

  public init(_ ranges: [AlmanacMapRange]) {
    self.ranges = ranges.sorted(by: { a, b in a.source < b.source })
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
  for i in (15_880_234..<99_999_999) {  // "answer - 2" inserted
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

public func computeLowestLocationByFlatten(_ input: [String]) -> Int {
  let (seedRanges, maps) = parseInputWithSeedRanges(input)
  let flattenedMap = flattenMaps(maps)
  print(flattenedMap)
  let sources = flattenedMap.ranges.map { $0.source }.filter { isValidSource($0, seedRanges) }
  return sources.map { flattenedMap.getDestination(ofSource: $0) }.min() ?? -1
}

struct Range: Hashable {
  let start: Int
  let end: Int
  init(_ start: Int, _ end: Int) {
    self.start = start
    self.end = end
  }
}

func isValidSource(_ source: Int, _ ranges: [SeedRange]) -> Bool {
  ranges.contains { source >= $0.start && source < $0.start + $0.range }
}

public func flattenMaps(_ maps: [AlmanacMap]) -> AlmanacMap {
  maps.reduce(AlmanacMap([]), { flattenMaps($0, $1) })
}

public func flattenMaps(_ first: AlmanacMap, _ second: AlmanacMap) -> AlmanacMap {
  let intermediateRanges = second.ranges.map { Range($0.source, $0.sourceEnd) }
  let newRanges = intermediateRanges.map { range in
    return Range(
      first.getSource(ofDestination: range.start), first.getSource(ofDestination: range.end))
  }.sorted(by: { a, b in a.start < b.start })
  let originalRanges = first.ranges.map {
    Range($0.source, $0.sourceEnd)
  }.sorted(by: { a, b in
    a.start < b.start
  })

  var combinedRanges: [Range] = []
  let largestRangeEnd = max(
    newRanges.map { $0.end }.max() ?? 0, originalRanges.map { $0.end }.max() ?? 0)
  var pointer = 0
  var isCreatingRange = false
  var lower = 0
  while pointer <= largestRangeEnd + 1 {
    print(pointer)
    print(isCreatingRange)
    if !isCreatingRange {
      let smallestNewStart =
        newRanges.filter { $0.start >= pointer }.first?.start ?? 999_999_999_999_999_999
      let smallestNewEnd =
        newRanges.filter { $0.end >= pointer }.first?.end ?? 999_999_999_999_999_999
      let smallestOrigStart =
        originalRanges.filter { $0.start >= pointer }.first?.start ?? 999_999_999_999_999_999
      let smallestOrigEnd =
        originalRanges.filter { $0.end >= pointer }.first?.end ?? 999_999_999_999_999_999
      let start = min(smallestNewStart, smallestNewEnd, smallestOrigStart, smallestOrigEnd)
      lower = start
      pointer = start + 1
      isCreatingRange = true
    } else {
      let smallestNewStart =
        newRanges.filter { $0.start >= pointer }.first?.start ?? 999_999_999_999_999_999
      let smallestNewEnd =
        newRanges.filter { $0.end >= pointer }.first?.end ?? 999_999_999_999_999_999
      let smallestOrigStart =
        originalRanges.filter { $0.start >= pointer }.first?.start ?? 999_999_999_999_999_999
      let smallestOrigEnd =
        originalRanges.filter { $0.end >= pointer }.first?.end ?? 999_999_999_999_999_999
      let end = min(smallestNewStart, smallestNewEnd, smallestOrigStart, smallestOrigEnd)
      if smallestNewEnd == end || smallestOrigEnd == end {
        combinedRanges.append(Range(lower, end))
        pointer = end
        isCreatingRange = false
      } else {
        combinedRanges.append(Range(lower, end))
        pointer = end
        isCreatingRange = false
      }
    }
  }
  print(pointer)
  print(isCreatingRange)
  let result = combinedRanges.map {
    AlmanacMapRange(
      source: $0.start,
      destination: second.getDestination(ofSource: first.getDestination(ofSource: $0.start)),
      length: $0.end - $0.start)
  }
  return AlmanacMap(result)
}
