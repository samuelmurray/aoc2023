import Utils

struct AocState: State {
  func successors() -> [Successor<AocState>] {
    if self.steps < minSteps {
      return [self.successor(direction: direction, steps: steps + 1)].compactMap { $0 }
    }
    return switch direction {
    case .right:
      [
        self.successor(direction: .right, steps: steps + 1),
        self.successor(direction: .up, steps: 1),
        self.successor(direction: .down, steps: 1),
      ].compactMap { $0 }
    case .left:
      [
        self.successor(direction: .left, steps: steps + 1),
        self.successor(direction: .up, steps: 1),
        self.successor(direction: .down, steps: 1),
      ].compactMap { $0 }
    case .up:
      [
        self.successor(direction: .up, steps: steps + 1),
        self.successor(direction: .left, steps: 1),
        self.successor(direction: .right, steps: 1),
      ].compactMap { $0 }
    case .down:
      [
        self.successor(direction: .down, steps: steps + 1),
        self.successor(direction: .left, steps: 1),
        self.successor(direction: .right, steps: 1),
      ].compactMap { $0 }
    }
  }

  func heuristic(_ goal: AocState) -> Int {
    return self.position.distance(to: goal.position)
  }

  func isAt(_ goal: AocState) -> Bool {
    return self.position == goal.position && self.steps >= minSteps
  }

  var id: String {
    return
      "\(position.x);\(position.y);\(steps);\(direction)"
  }

  let position: Position
  let direction: Direction
  let steps: Int
  let minSteps: Int
  let maxSteps: Int
  let map: Map
}

extension AocState: Equatable, Hashable, Comparable {
  static func == (lhs: AocState, rhs: AocState) -> Bool {
    return lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  static func < (lhs: AocState, rhs: AocState) -> Bool {
    return false
  }
}

extension AocState {
  func successor(direction: Direction, steps: Int) -> Successor<AocState>? {
    if steps > maxSteps {
      return nil
    }
    let nextPosition = self.position.move(direction: direction)
    guard let cost = self.map[nextPosition] else {
      return nil  // Outside map
    }
    let nextState = AocState(
      position: nextPosition, direction: direction, steps: steps, minSteps: minSteps,
      maxSteps: maxSteps, map: map)
    return Successor(state: nextState, cost: cost)
  }
}

struct Map {
  private let tiles: [[Int]]

  init(_ tiles: [[Int]]) {
    self.tiles = tiles
  }
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

  func distance(to other: Position) -> Int {
    return abs(self.x - other.x) + abs(self.y - other.y)
  }
}

extension Map {
  var dimensions: (x: Int, y: Int) {
    (self.tiles[0].count, self.tiles.count)
  }

  func isValid(pos: Position) -> Bool {
    return pos.x >= 0 && pos.x < self.dimensions.x && pos.y >= 0 && pos.y < self.dimensions.y
  }

  subscript(_ x: Int, _ y: Int) -> Int? {
    if !isValid(pos: Position(x, y)) {
      return nil
    }
    return self.tiles[y][x]
  }

  subscript(_ pos: Position) -> Int? {
    self[pos.x, pos.y]
  }
}

extension Map {
  func printPath(_ path: [AocState]) {
    var s = ""
    for y in 0..<self.dimensions.y {
      for x in 0..<self.dimensions.x {
        if path.contains(where: { $0.position == Position(x, y) }) {
          s += "X"
        } else {
          s += " "  //String(self[x, y]!)
        }
      }
      s += "\n"
    }
    print(s)
  }
}

enum Direction {
  case right, left, up, down
}

func parseMap(_ input: [String]) -> Map {
  var tiles: [[Int]] = []
  for line in input {
    var row: [Int] = []
    for char in line {
      row.append(char.wholeNumberValue!)
    }
    tiles.append(row)
  }
  return Map(tiles)
}

func solve(_ input: [String], minSteps: Int, maxSteps: Int) throws -> Int {
  let map = parseMap(input)
  let start1 = AocState(
    position: Position(0, 0), direction: .right, steps: 0, minSteps: minSteps, maxSteps: maxSteps,
    map: map)
  let start2 = AocState(
    position: Position(0, 0), direction: .down, steps: 0, minSteps: minSteps, maxSteps: maxSteps,
    map: map)
  let goalPosition = Position(map.dimensions.x - 1, map.dimensions.y - 1)
  guard
    let solution = AStar(
      start: [start1, start2],
      goal: AocState(
        position: goalPosition, direction: .right, steps: 1, minSteps: minSteps, maxSteps: maxSteps,
        map: map)
    )
  else {
    throw AocError.runtimeError("No plan found!")
  }
  //map.printPath(solution.path)
  return solution.cost
}
