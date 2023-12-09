struct OasisHistory {
  let values: [Int]

  static func parse(_ input: String) -> OasisHistory {
    let values = input.split(separator: " ")
      .map { Int($0)! }
    return OasisHistory(values: values)
  }
}

extension OasisHistory {
  func predictNext() -> Int {
    return values.predictNext()
  }

  func predictPrevious() -> Int {
    return values.predictPrevious()
  }
}

extension [Int] {
  func predictNext() -> Int {
    if (self.allSatisfy { $0 == 0 }) {
      return 0
    }
    return self.last! + self.deltas().predictNext()
  }

  func predictPrevious() -> Int {
    if (self.allSatisfy { $0 == 0 }) {
      return 0
    }
    return self.first! - self.deltas().predictPrevious()
  }

  func deltas() -> [Int] {
    var deltas: [Int] = []
    for i in (1..<self.count) {
      deltas.append(self[i] - self[i - 1])
    }
    return deltas
  }
}

func computeSum1(_ input: [String]) -> Int {
  input.map { OasisHistory.parse($0) }
    .map { $0.predictNext() }
    .reduce(0, +)
}

func computeSum2(_ input: [String]) -> Int {
  input.map { OasisHistory.parse($0) }
    .map { $0.predictPrevious() }
    .reduce(0, +)
}
