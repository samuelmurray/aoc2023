import Foundation
import Utils

public struct Time: RowObject {
  public static var regexp = try! NSRegularExpression(pattern: "\\d+")

  let timeMs: Int

  public init(content: String) throws {
    guard let timeMs = Int(content) else {
      throw AocError.runtimeError("Bad input: \(content)")
    }
    self.timeMs = timeMs
  }

  public init(_ timeMs: Int) {
    self.timeMs = timeMs
  }
}

public struct Distance: RowObject, Comparable {
  public static func < (lhs: Distance, rhs: Distance) -> Bool {
    lhs.distanceMm < rhs.distanceMm
  }

  public static var regexp = try! NSRegularExpression(pattern: "\\d+")

  public let distanceMm: Int

  public init(content: String) throws {
    guard let distanceMm = Int(content) else {
      throw AocError.runtimeError("Bad input: \(content)")
    }
    self.distanceMm = distanceMm
  }

  public init(_ distanceMm: Int) {
    self.distanceMm = distanceMm
  }
}

public struct Race {
  let timeLimit: Time
  let recordDistance: Distance

  public init(_ timeLimit: Time, _ recordDistance: Distance) {
    self.timeLimit = timeLimit
    self.recordDistance = recordDistance
  }
}

public func computeDistances(_ race: Race) -> [Distance] {
  let maxTimeMs = race.timeLimit.timeMs
  return (0..<maxTimeMs + 1).map { timeMs in
    Distance(timeMs * (maxTimeMs - timeMs))
  }
}

public func computeNumberOfWinningWindupTimes(_ race: Race) -> Int {
  computeDistances(race).filter { $0 > race.recordDistance }.count
}

public func computeProduct(_ input: [String]) throws -> Int {
  if input.count != 2 {
    throw AocError.runtimeError("Input not of length 2")
  }
  let times = parseRowObjects(input: input[0], type: Time.self)
  let distances = parseRowObjects(input: input[1], type: Distance.self)
  var races: [Race] = []
  for (time, distance) in zip(times, distances) {
    races.append(Race(time, distance))
  }
  return races.map{computeNumberOfWinningWindupTimes($0)}.reduce(1, *)
}
