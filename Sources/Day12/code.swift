import Utils

struct ConditionRecord: Equatable, Hashable {
  let springs: [SpringCondition]
}

enum SpringCondition {
  case operational, damaged, unknown
}

extension ConditionRecord {
  func isCompatible(with other: ConditionRecord) throws -> Bool {
    if self.springs.count != other.springs.count {
      throw AocError.runtimeError("Different lengths of springs!")
    }
    return zip(self.springs, other.springs).allSatisfy { pair in pair.0.isCompatible(with: pair.1) }
  }
}

extension SpringCondition {
  func isCompatible(with other: SpringCondition) -> Bool {
    return self == other || self == .unknown || other == .unknown
  }
}

extension ArraySlice where Element == SpringCondition {
  func isCompatible(with other: [SpringCondition]) -> Bool {
    return zip(self, other).allSatisfy { pair in pair.0.isCompatible(with: pair.1) }
  }
}

var isCompatibleHash: [ArraySlice<SpringCondition>: [SpringCondition]] = [:]

func countValidCombinations(_ reference: ConditionRecord, _ contiguousGroups: [Int]) throws -> Int {
  try generatePossibleRecords(reference, contiguousGroups).count
}

func generatePossibleRecords(_ reference: ConditionRecord, _ contiguousGroups: [Int]) throws
  -> [ConditionRecord]
{
  return try generatePossibleRecordsRecursive(
    ArraySlice(reference.springs), ArraySlice(contiguousGroups)
  )
  .map { ConditionRecord(springs: $0) }
}

struct Input: Hashable {
  let reference: [SpringCondition]
  let contiguousGroups: [Int]
}

var cache: [Input: [[SpringCondition]]] = [:]

func generatePossibleRecordsRecursive(
  _ reference: ArraySlice<SpringCondition>, _ contiguousGroups: ArraySlice<Int>
) throws
  -> [[SpringCondition]]
{
  let input = Input(reference: Array(reference), contiguousGroups: Array(contiguousGroups))
  if let cached = cache[input] {
    return cached
  }
  if contiguousGroups.count == 0 {
    throw AocError.runtimeError("Bad input! Empty groups")
  }
  if contiguousGroups.reduce(0, +) + contiguousGroups.count - 1 > reference.count {
    throw AocError.runtimeError("Bad input! \(contiguousGroups) too big for \(reference.count)")
  }
  let firstGroup = contiguousGroups.first!
  var conditions: [[SpringCondition]] = []
  if contiguousGroups.count == 1 {
    for i in 0...reference.count - firstGroup {
      var tmp = Array(repeating: SpringCondition.operational, count: reference.count)
      tmp.replaceSubrange(
        i..<i + firstGroup, with: Array(repeating: SpringCondition.damaged, count: firstGroup))
      if !reference.prefix(tmp.count).isCompatible(with: tmp) {
        continue
      }
      conditions.append(tmp)
    }
    cache[input] = conditions
    return conditions
  }
  let lastPossibleStart =
    reference.count - (contiguousGroups.reduce(0, +) + contiguousGroups.count - 1)
  for i in (0...lastPossibleStart).reversed() {
    let start =
      Array(repeating: SpringCondition.operational, count: i)
      + Array(repeating: SpringCondition.damaged, count: firstGroup) + [.operational]
    if !reference.prefix(start.count).isCompatible(with: start) {
      continue
    }
    let ends = try generatePossibleRecordsRecursive(
      reference.dropFirst(start.count), contiguousGroups.dropFirst())
    conditions.append(contentsOf: ends.map { start + $0 })
  }
  cache[input] = conditions
  return conditions
}

func computeSum(_ input: [String], duplications: Int = 1) throws -> Int {
  try input.map { line in
    let parts = line.split(separator: " ")
    let conditions = try parts[0].map { char in
      switch char {
      case ".": return SpringCondition.operational
      case "#": return .damaged
      case "?": return .unknown
      default: throw AocError.runtimeError("Bad input \(char)")
      }
    }
    var repeatedConditions = conditions
    for _ in 1..<duplications {
      repeatedConditions.append(.unknown)
      repeatedConditions.append(contentsOf: conditions)
    }
    let groups = parts[1].split(separator: ",").map { Int($0)! }.repeated(count: duplications)
    return try countValidCombinations(ConditionRecord(springs: repeatedConditions), groups)
  }.reduce(0, +)
}
