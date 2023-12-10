import Utils

struct Map {
  private let tiles: [[Tile]]

  init(_ tiles: [[Tile]]) {
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
  var north: Position {
    return Position(self.x, self.y - 1)
  }
  var south: Position {
    return Position(self.x, self.y + 1)
  }
  var west: Position {
    return Position(self.x - 1, self.y)
  }
  var east: Position {
    return Position(self.x + 1, self.y)
  }
}

extension Map {
  var dimensions: (x: Int, y: Int) {
    (self.tiles[0].count, self.tiles.count)
  }

  func isValid(pos: Position) -> Bool {
    return pos.x >= 0 && pos.x < self.dimensions.x && pos.y >= 0 && pos.y < self.dimensions.y
  }

  subscript(_ x: Int, _ y: Int) -> Tile? {
    if !isValid(pos: Position(x, y)) {
      return nil
    }
    return self.tiles[y][x]
  }

  func neighbours(of pos: Position) throws -> [Position] {
    guard let tile = self[pos.x, pos.y] else {
      throw AocError.runtimeError("Bad input position \(pos)")
    }
    switch tile.type {
    case .ns: return [pos.north, pos.south].filter { self.isValid(pos: $0) }
    case .ew: return [pos.east, pos.west].filter { self.isValid(pos: $0) }
    case .ne: return [pos.north, pos.east].filter { self.isValid(pos: $0) }
    case .nw: return [pos.north, pos.west].filter { self.isValid(pos: $0) }
    case .sw: return [pos.south, pos.west].filter { self.isValid(pos: $0) }
    case .se: return [pos.south, pos.east].filter { self.isValid(pos: $0) }
    case .ground: return []
    case .start:
      let ret = try [pos.north, pos.east, pos.south, pos.west]
        .filter { self.isValid(pos: $0) }
        .filter { try self.neighbours(of: $0).contains(pos) }
      if ret.count != 2 {
        throw AocError.runtimeError("Start has \(ret.count) neighbours")
      }
      return ret
    }
  }

  func neighbours(of: (x: Int, y: Int)) throws -> [Position] {
    return try self.neighbours(of: Position(of.x, of.y))
  }

  var startPosition: Position? {
    for (y, column) in self.tiles.enumerated() {
      for (x, tile) in column.enumerated() {
        if tile.type == .start {
          return Position(x, y)
        }
      }
    }
    return nil
  }

  func loop(from start: Position) throws -> [Position] {
    var loop = [start]
    var pos = try self.neighbours(of: start)[0]
    while pos != start {
      let next = try self.neighbours(of: pos).filter { $0 != loop.last }.first!
      loop.append(pos)
      pos = next
    }
    return loop
  }
}

struct Tile: Equatable {
  let type: TileType
}

enum TileType {
  case ns, ew, ne, nw, sw, se, ground, start
}

func parseMap(_ input: [String]) -> Map {
  var tiles: [[Tile]] = []
  for line in input {
    var row: [Tile] = []
    for char in line {
      switch char {
      case "|": row.append(Tile(type: .ns))
      case "-": row.append(Tile(type: .ew))
      case "L": row.append(Tile(type: .ne))
      case "J": row.append(Tile(type: .nw))
      case "7": row.append(Tile(type: .sw))
      case "F": row.append(Tile(type: .se))
      case ".": row.append(Tile(type: .ground))
      case "S": row.append(Tile(type: .start))
      default: continue
      }
    }
    tiles.append(row)
  }
  return Map(tiles)
}

func computeFarthestPosition(_ input: [String]) throws -> Int {
  let map = parseMap(input)
  return try map.loop(from: map.startPosition!).count / 2
}

func isInside(_ pos: Position, _ map: Map, _ loop: any Collection<Position>) throws -> Bool {
  if loop.contains(pos) {
    return false
  }
  var numIntersections = 0
  for x in (0..<pos.x) {
    let pos = Position(x, pos.y)
    if loop.contains(pos) {
      switch map[pos.x, pos.y]!.type {
      case .ns, .ne, .nw:
        numIntersections += 1
      default:
        continue
      }
    }
  }
  return numIntersections % 2 == 1
}

func computeEnclosedRegion(_ input: [String]) throws -> Int {
  let map = parseMap(input)
  let loop = Set(try map.loop(from: map.startPosition!))
  var enclosed: [Position] = []
  for x in (0..<map.dimensions.x) {
    for y in (0..<map.dimensions.y) {
      let pos = Position(x, y)
      if try isInside(pos, map, loop) {
        enclosed.append(pos)
      }
    }
  }
  return enclosed.count
}
