import Algorithms

struct Image {
  let galaxies: Set<Galaxy>
}

struct Galaxy: Hashable {
  let x: Int
  let y: Int
}

extension Image {
  var rowsToExpand: Set<Int> {
    let rows = Set(self.galaxies.map { $0.y })
    let (min, max) = rows.minAndMax()!
    return rows.symmetricDifference((min...max))
  }

  var columnsToExpand: Set<Int> {
    let rows = Set(self.galaxies.map { $0.x })
    let (min, max) = rows.minAndMax()!
    return rows.symmetricDifference((min...max))
  }
}

func parseImage(_ input: [String]) -> Image {
  var galaxies: Set<Galaxy> = []
  for (y, line) in input.enumerated() {
    for (x, char) in line.enumerated() {
      if char == "#" {
        galaxies.insert(Galaxy(x: x, y: y))
      }
    }
  }
  return Image(galaxies: galaxies)
}

func computePairwiseDistances(_ image: Image, expansion: Int) -> [Int] {
  let pairs = image.galaxies.combinations(ofCount: 2)
  let rowsToExpand = image.rowsToExpand
  let columnsToExpand = image.columnsToExpand
  return pairs.map { pair in
    let distance = computeDistance(pair[0], pair[1])
    return distance + (expansion - 1)
      * (countInRange(rowsToExpand, [pair[0].y, pair[1].y].minAndMax()!)
        + countInRange(columnsToExpand, [pair[0].x, pair[1].x].minAndMax()!))
  }
}

func countInRange(_ rows: any Collection<Int>, _ range: (min: Int, max: Int)) -> Int {
  rows.filter { $0 > range.min && $0 < range.max }.count
}

func computeDistance(_ a: Galaxy, _ b: Galaxy) -> Int {
  abs(a.x - b.x) + abs(a.y - b.y)
}

func computeSum(_ input: [String], expansion: Int = 2) -> Int {
  let image = parseImage(input)
  let distances = computePairwiseDistances(image, expansion: expansion)
  return distances.reduce(0, +)
}
