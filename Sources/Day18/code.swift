import Utils

enum Direction {
  case up, down, right, left
}

enum Orientation {
  case southCorner, northCorner, vertical, horizontal
}

struct Trench {
  var edge: [Position: Orientation]
}

extension Trench {
  func enclosedRegion() -> Set<Position> {
    var enclosed = Set(edge.map { $0.key })
    let xRange = edge.map { $0.key.x }.minAndMax()!
    let yRange = edge.map { $0.key.y }.minAndMax()!
    for x in (xRange.min...xRange.max) {
      for y in (yRange.min...yRange.max) {
        let pos = Position(x, y)
        if isInside(pos, edge, xRange.min) {
          enclosed.insert(pos)
        }
      }
    }
    return enclosed
  }
}

func isInside(_ position: Position, _ edge: [Position: Orientation], _ xMin: Int) -> Bool {
  if edge.keys.contains(position) {
    return false
  }
  var numIntersections = 0
  for x in (xMin..<position.x) {
    let pos = Position(x, position.y)
    if let orientation = edge[pos] {
      switch orientation {
      case .vertical, .southCorner:
        numIntersections += 1
      default:
        continue
      }
    }
  }
  return numIntersections % 2 == 1
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
  var up: Position {
    return Position(self.x, self.y - 1)
  }
  var down: Position {
    return Position(self.x, self.y + 1)
  }
  var left: Position {
    return Position(self.x - 1, self.y)
  }
  var right: Position {
    return Position(self.x + 1, self.y)
  }

  func move(direction: Direction) -> Position {
    switch direction {
    case .up: self.up
    case .right: self.right
    case .left: self.left
    case .down: self.down
    }
  }
}

struct DigInstruction {
  let direction: Direction
  let steps: Int
  let color: String
}

func parseTrench(_ input: [String]) throws -> Trench {
  var position = Position(0, 0)
  var edgePieces = [position]
  for line in input {
    let parts = line.split(separator: " ")
    let direction = try parseDirection(parts[0].first!)
    let steps = Int(parts[1])!
    for _ in 0..<steps {
      position = position.move(direction: direction)
      edgePieces.append(position)
    }
  }

  var edge: [Position: Orientation] = [:]
  for i in edgePieces.dropFirst().dropLast().indices {
    let pos = edgePieces[i]
    let previous = edgePieces[i - 1]
    let next = edgePieces[i + 1]
    edge[pos] = try determineOrientation(previous: previous, current: pos, next: next)
  }
  edge[edgePieces.first!] = try determineOrientation(
    previous: edgePieces.last!, current: edgePieces.first!, next: edgePieces[1])
  edge[edgePieces.last!] = try determineOrientation(
    previous: edgePieces[edgePieces.count - 2], current: edgePieces.last!, next: edgePieces.first!)

  return Trench(edge: edge)
}

func determineOrientation(previous: Position, current: Position, next: Position) throws
  -> Orientation
{
  if previous.y == current.y && next.y == current.y {
    return .horizontal
  } else if previous.x == current.x && next.x == current.x {
    return .vertical
  } else if previous.y > current.y || next.y > current.y {
    return .southCorner
  } else if previous.y < current.y || next.y < current.y {
    return .northCorner
  } else {
    throw AocError.runtimeError("Bad input")
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

func computeArea(_ input: [String]) throws -> Int {
  let trench = try parseTrench(input)
  return trench.enclosedRegion().count
}
