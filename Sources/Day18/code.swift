import Utils

enum Direction {
  case up, down, right, left
}

struct Position: Equatable, Hashable {
  let x: Int
  let y: Int
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
}

extension Position {
  func move(direction: Direction, steps: Int) -> Position {
    switch direction {
    case .up: Position(x, y - steps)
    case .down: Position(x, y + steps)
    case .right: Position(x + steps, y)
    case .left: Position(x - steps, y)
    }
  }
}

func parseDirection(_ input: Character) throws -> Direction {
  return switch input {
  case "R": .right
  case "D": .down
  case "U": .up
  case "L": .left
  default: throw AocError.runtimeError("Bad input \(input)")
  }
}

func parseDirectionHex(_ input: Character) throws -> Direction {
  return switch input {
  case "0": .right
  case "1": .down
  case "2": .left
  case "3": .up
  default: throw AocError.runtimeError("Bad input \(input)")
  }
}

func computeTurn(newDirection: Direction, previousDirection: Direction) -> Turn {
  return switch newDirection {
  case .up: previousDirection == .right ? .left : .right
  case .down: previousDirection == .right ? .right : .left
  case .right: previousDirection == .up ? .right : .left
  case .left: previousDirection == .up ? .left : .right
  }
}

enum Turn {
  case left, right
}

struct Polygon {
  let corners: [Position]
  let turns: [Turn]
}

extension Polygon {
  func area() -> Int {
    var area = 0
    var j = corners.count - 1
    for i in 0..<corners.count {
      area += (corners[j].x + corners[i].x) * (corners[j].y - corners[i].y)
      area += max(abs(corners[j].x - corners[i].x) - 1, 0)
      area += max(abs(corners[j].y - corners[i].y) - 1, 0)
      j = i
    }
    let turnArea = turns.map {$0 == .left ? 1 : 3}.reduce(0, +) / 4
    return abs(area / 2) + turnArea
  }
}

func computeArea(_ input: [String]) throws -> Int {
  let polygon = try parsePolygon(input)
  return polygon.area()
}

func computeAreaHex(_ input: [String]) throws -> Int {
  let polygon = try parsePolygonHex(input)
  return polygon.area()
}


func parsePolygonHex(_ input: [String]) throws -> Polygon {
  var position = Position(0, 0)
  var corners: [Position] = []
  var turns: [Turn] = []

  let parts = input.last!.split(separator: " ")
  var lastDirection = try parseDirectionHex(parts[2].dropLast().last!)

  for line in input {
    let parts = line.split(separator: " ")
    let hex = parts[2].dropFirst().dropFirst().dropLast()
    let direction = try parseDirectionHex(hex.last!)
    let steps = Int(hex.dropLast(), radix: 16)!
    position = position.move(direction: direction, steps: steps)
    corners.append(position)

    turns.append(computeTurn(newDirection: direction, previousDirection: lastDirection))
    lastDirection = direction
  }
  return Polygon(corners: corners.reversed(), turns: turns)
}

func parsePolygon(_ input: [String]) throws -> Polygon {
  var position = Position(0, 0)
  var corners: [Position] = []
  var turns: [Turn] = []

  let parts = input.last!.split(separator: " ")
  var lastDirection = try parseDirection(parts[0].first!)

  for line in input {
    let parts = line.split(separator: " ")
    let direction = try parseDirection(parts[0].first!)
    let steps = Int(parts[1])!
    position = position.move(direction: direction, steps: steps)
    corners.append(position)

    turns.append(computeTurn(newDirection: direction, previousDirection: lastDirection))
    lastDirection = direction
  }
  return Polygon(corners: corners.reversed(), turns: turns)
}
