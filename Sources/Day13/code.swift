import Algorithms
import Foundation
import Utils

func findReflectionLine(_ input: [String], numSmudges: Int = 0) -> Int? {
  for i in (1..<input.count) {
    let low = input[0..<i]
    let high = input[i..<input.count]
    if low.mirrors(high, numSmudges: numSmudges) {
      return i
    }
  }
  return nil
}

func transpose(_ input: [String]) -> [String] {
  var transposed: [String] = []
  for x in 0..<input[0].count {
    transposed.append(input.map { String($0[x]) }.joined())
  }
  return transposed
}

extension ArraySlice where Element == String {
  func mirrors(_ other: ArraySlice, numSmudges: Int) -> Bool {
    let selfReversed = ArraySlice(self.reversed())
    let length = Swift.min(self.count, other.count)
    var dist = 0
    if numSmudges == 0 {
      return selfReversed[selfReversed.startIndex..<selfReversed.startIndex + length]
        == other[other.startIndex..<other.startIndex + length]
    }
    for (a, b) in zip(
      selfReversed[selfReversed.startIndex..<selfReversed.startIndex + length],
      other[other.startIndex..<other.startIndex + length])
    {
      dist += levDist(a, b)
      if dist > numSmudges {
        return false
      }
    }
    return dist == numSmudges
  }
}

func computeSum(_ input: [String], numSmudges: Int = 0) -> Int {
  var sum = 0
  let groups = input.split(separator: "").map { Array($0) }
  for pattern in groups {
    if let reflection = findReflectionLine(pattern, numSmudges: numSmudges) {
      sum += 100 * reflection
    } else if let reflection = findReflectionLine(transpose(pattern), numSmudges: numSmudges) {
      sum += reflection
    }
  }
  return sum
}

func levDist(_ w1: String, _ w2: String) -> Int {
  let empty = [Int](repeating: 0, count: w2.count)
  var last = [Int](0...w2.count)

  for (i, char1) in w1.enumerated() {
    var cur = [i + 1] + empty
    for (j, char2) in w2.enumerated() {
      cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
    }
    last = cur
  }
  return last.last!
}
