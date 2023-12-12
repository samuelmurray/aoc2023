import Utils

struct ConditionRecord: Equatable {
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

func countValidCombinations(_ reference: ConditionRecord, _ contiguousGroups: [Int]) throws -> Int {
  try generatePossibleRecords(contiguousGroups, reference.springs.count)
    .filter {
      try reference.isCompatible(with: $0)
    }.count
}

func generatePossibleRecords(_ contiguousGroups: [Int], _ size: Int) throws -> [ConditionRecord] {
  return try generatePossibleRecordsRecursive(ArraySlice(contiguousGroups), size)
    .map { ConditionRecord(springs: $0) }
}

func generatePossibleRecordsRecursive(_ contiguousGroups: ArraySlice<Int>, _ size: Int) throws
  -> [[SpringCondition]]
{
  if contiguousGroups.count == 0 {
    throw AocError.runtimeError("Bad input! Empty groups")
  }
  if contiguousGroups.reduce(0, +) + contiguousGroups.count - 1 > size {
    throw AocError.runtimeError("Bad input! \(contiguousGroups) too big for \(size)")
  }
  let firstGroup = contiguousGroups.first!
  var conditions: [[SpringCondition]] = []
  if contiguousGroups.count == 1 {

    for i in 0...size - firstGroup {
      var tmp = Array(repeating: SpringCondition.operational, count: size)
      tmp.replaceSubrange(
        i..<i + firstGroup, with: Array(repeating: SpringCondition.damaged, count: firstGroup))
      conditions.append(tmp)
    }
    return conditions
  }
  let lastPossibleStart = size - (contiguousGroups.reduce(0, +) + contiguousGroups.count - 1)
  for i in 0...lastPossibleStart {
    let start =
      Array(repeating: SpringCondition.operational, count: i)
      + Array(repeating: SpringCondition.damaged, count: firstGroup) + [.operational]
    let ends = try generatePossibleRecordsRecursive(
      contiguousGroups.dropFirst(), size - (i + firstGroup + 1))
    conditions.append(contentsOf: ends.map { start + $0 })
  }
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
