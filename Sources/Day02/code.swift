import Utils

public struct Subset: Equatable {
  let reds: Int
  let greens: Int
  let blues: Int

  public init(reds: Int, greens: Int, blues: Int) {
    self.reds = reds
    self.greens = greens
    self.blues = blues
  }

  public func isGreaterThan(_ other: Subset) -> Bool {
    return reds >= other.reds && greens >= other.greens && blues >= other.blues
  }
}

public func parseGame(_ input: String) -> (id: Int, subsets: [Subset]) {
  let splitInput = input.split(separator: ":")
  let game = splitInput.first!.split(separator: " ")
  let id = Int(game.last!)!
  let subsets = splitInput.last!
    .split(separator: ";")
    .map { input in parseSubset(String(input)) }
  return (id, subsets)
}

func parseSubset(_ input: String) -> Subset {
  let colors = input.split(separator: ",").map { $0.trimmingPrefix(" ") }
  let reds =
    colors.filter { String($0).split(separator: " ").last == "red" }.first?.split(separator: " ")
    .first ?? "0"
  let greens =
    colors.filter { String($0).split(separator: " ").last == "green" }.first?.split(separator: " ")
    .first ?? "0"
  let blues =
    colors.filter { String($0).split(separator: " ").last == "blue" }.first?.split(separator: " ")
    .first ?? "0"
  return Subset(reds: Int(reds)!, greens: Int(greens)!, blues: Int(blues)!)
}

public func isPossible(_ subsets: [Subset], _ bag: Subset) -> Bool {
  return subsets.allSatisfy { bag.isGreaterThan($0) }
}

public func smallestPossibleBag(_ subsets: [Subset]) -> Subset {
  let (reds, greens, blues) = subsets.reduce(
    (0, 0, 0), { (max($0.0, $1.reds), max($0.1, $1.greens), max($0.2, $1.blues)) })
  return Subset(reds: reds, greens: greens, blues: blues)
}

func powerOfBag(_ bag: Subset) -> Int {
  return bag.reds * bag.greens * bag.blues
}

public func computeSum(_ input: [String], _ bag: Subset) -> Int {
  return input.map { parseGame($0) }
    .filter { isPossible($0.subsets, bag) }
    .map { $0.id }
    .reduce(0, +)
}

public func computeSumOfSmallestBags(_ input: [String]) -> Int {
  return input.map { parseGame($0) }
    .map { smallestPossibleBag($0.subsets) }
    .map { powerOfBag($0) }
    .reduce(0, +)
}
