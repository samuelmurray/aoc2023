import Algorithms
import Collections
import Foundation
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

  subscript(_ pos: Position) -> Tile? {
    self[pos.x, pos.y]
  }

  func advance(_ beamFront: BeamFront) -> [BeamFront] {
    self.innerAdvance(beamFront).filter { self.isValid(pos: $0.position) }
  }

  private func innerAdvance(_ beamFront: BeamFront) -> [BeamFront] {
    switch self[beamFront.position]! {
    case .emptySpace: return [beamFront.advance(beamFront.direction)]
    case .mirrorRight:
      return switch beamFront.direction {
      case .right: [beamFront.advance(.up)]
      case .left: [beamFront.advance(.down)]
      case .up: [beamFront.advance(.right)]
      case .down: [beamFront.advance(.left)]
      }
    case .mirrorLeft:
      return switch beamFront.direction {
      case .right: [beamFront.advance(.down)]
      case .left: [beamFront.advance(.up)]
      case .up: [beamFront.advance(.left)]
      case .down: [beamFront.advance(.right)]
      }
    case .splitterVertical:
      return switch beamFront.direction {
      case .right, .left: [beamFront.advance(.up), beamFront.advance(.down)]
      case .up, .down: [beamFront.advance(beamFront.direction)]
      }
    case .splitterHorizontal:
      return switch beamFront.direction {
      case .right, .left: [beamFront.advance(beamFront.direction)]
      case .up, .down: [beamFront.advance(.left), beamFront.advance(.right)]
      }
    }
  }
}

struct BeamFront: Hashable {
  let position: Position
  let direction: Direction
}

extension BeamFront {
  func advance(_ direction: Direction) -> BeamFront {
    BeamFront(position: self.position.move(direction: direction), direction: direction)
  }
}

enum Direction {
  case right, left, up, down
}

enum Tile {
  case emptySpace, mirrorRight, mirrorLeft, splitterVertical, splitterHorizontal
}

func parseMap(_ input: [String]) -> Map {
  var tiles: [[Tile]] = []
  for line in input {
    var row: [Tile] = []
    for char in line {
      switch char {
      case ".": row.append(.emptySpace)
      case "/": row.append(.mirrorRight)
      case "\\": row.append(.mirrorLeft)
      case "|": row.append(.splitterVertical)
      case "-": row.append(.splitterHorizontal)
      default: continue
      }
    }
    tiles.append(row)
  }
  return Map(tiles)
}

func compute1(_ input: [String]) -> Int {
  let map = parseMap(input)
  let startBeam = BeamFront(position: Position(0, 0), direction: .right)
  return numberOfEnergizedTiles(map, startBeam)
}

func compute2(_ input: [String]) -> Int {
  let map = parseMap(input)
  var startBeams: [BeamFront] = []
  for x in 0..<map.dimensions.x {
    startBeams.append(BeamFront(position: Position(x, 0), direction: .down))
    startBeams.append(BeamFront(position: Position(x, map.dimensions.y - 1), direction: .up))
  }
  for y in 0..<map.dimensions.y {
    startBeams.append(BeamFront(position: Position(0, y), direction: .right))
    startBeams.append(BeamFront(position: Position(map.dimensions.x - 1, y), direction: .left))
  }
  return startBeams.map { numberOfEnergizedTiles(map, $0) }.max() ?? 0
}

func numberOfEnergizedTiles(_ map: Map, _ startBeam: BeamFront) -> Int {
  var previousBeams: Set<BeamFront> = [startBeam]
  var beams: Deque<BeamFront> = [startBeam]
  while !beams.isEmpty {
    let beam = beams.popFirst()!
    let result = map.advance(beam)
    for newBeam in result {
      if !previousBeams.contains(newBeam) {
        previousBeams.insert(newBeam)
        beams.append(newBeam)
      }
    }
  }
  return previousBeams.uniqued(on: { $0.position }).count
}
