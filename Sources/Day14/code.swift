import Foundation
import Utils

func rollWest(_ input: any StringProtocol) -> String {
  let parts = input.split(separator: "#", omittingEmptySubsequences: false).map {
    $0.sorted().reversed()
  }.joined(separator: "#")
  return String(parts)
}

func computeLoad(_ input: any StringProtocol) -> Int {
  input.reversed().enumerated()
    .reduce(
      0,
      { (sum, e) in
        e.element == "O" ? sum + e.offset + 1 : sum
      })
}

func computeSum(_ input: [String]) -> Int {
  input.transposed().map { rollWest($0) }.map { computeLoad($0) }.reduce(0, +)
}

func spinCycle(_ input: [String]) -> [String] {
  let north = input.transposed().map { rollWest($0) }.transposed()  // north
  let west = north.map { rollWest($0) }
  let south = west.transposed().map { String($0.reversed()) }.map { rollWest($0) }.map {
    String($0.reversed())
  }.transposed()  // south
  let east = south.map { String($0.reversed()) }.map { rollWest($0) }.map { String($0.reversed()) }  // east
  return east
}

func computeSum(_ input: [String], numCycles: Int) -> Int {
  var seenConfigs: [[String]: Int] = [:]
  var configuration = input
  var i = 0
  var cycleFound = false
  while i < numCycles {
    configuration = spinCycle(configuration)
    if !cycleFound {
      if let firstSeen = seenConfigs[configuration] {
        let cycleLength = i - firstSeen
        i = numCycles - ((numCycles - i) % cycleLength)
        cycleFound = true
      } else {
        seenConfigs[configuration] = i
      }
    }
    i += 1
  }
  return configuration.transposed().map { computeLoad($0) }.reduce(0, +)
}
