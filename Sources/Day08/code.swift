import Foundation
import Utils

public class Node {

  static let regexp = try! NSRegularExpression(
    pattern: "([A-Z0-9]{3}) = \\(([A-Z0-9]{3}), ([A-Z0-9]{3})\\)")

  internal init(_ position: String, _ left: String, _ right: String) {
    self.position = position
    self.left = left
    self.right = right
  }

  public let position: String
  public let left: String
  public let right: String
  public var leftNode: Node?
  public var rightNode: Node?
}

public struct Instruction {
  let directions: String
}

public func parseLine(_ input: String) throws -> Node {
  let groups = input.groups(Node.regexp)[0]
  return Node(groups[1], groups[2], groups[3])
}

public func parseInput(_ input: any Collection<String>) throws -> [Node] {
  let nodes = try input.map { try parseLine($0) }
  postProcess(nodes)
  return nodes
}

public func postProcess(_ nodes: [Node]) {
  let nodeDict = nodes.reduce(into: [String: Node](), { $0[$1.position] = $1 })
  for node in nodes {
    node.leftNode = nodeDict[node.left]
    node.rightNode = nodeDict[node.right]
  }
}

public func computeNumberOfSteps(_ input: [String]) throws -> Int {
  let instruction = input.first!
  let nodes = try parseInput(input.suffix(from: 2))
  let startNode = nodes.first(where: { $0.position == "AAA" })!
  return try computeNumberOfSteps(
    startingAt: startNode, endingAt: { $0.position == "ZZZ" }, instruction, nodes)
}

public func computeNumberOfSteps(
  startingAt: Node, endingAt: ((Node) -> Bool), _ instruction: String, _ nodes: [Node]
) throws -> Int {
  var currentNode = startingAt
  var index = instruction.startIndex
  var i = 0
  var numSteps = 0
  while true {
    index = instruction.index(instruction.startIndex, offsetBy: i)
    if instruction[index] == "L" {
      currentNode = currentNode.leftNode!
    } else if instruction[index] == "R" {
      currentNode = currentNode.rightNode!
    } else {
      throw AocError.runtimeError("Bad next instruction \(instruction[index])")
    }
    i = (i + 1) % instruction.count
    numSteps += 1
    if endingAt(currentNode) {
      break
    }
  }
  return numSteps
}

public func computeNumberOfStepsGhost(_ input: [String]) throws -> Int {
  let instruction = input.first!
  let nodes = try parseInput(input.suffix(from: 2))
  let startNodes = nodes.filter { $0.position.suffix(fromBack: 1) == "A" }
  var steps: [Int] = []
  for startNode in startNodes {
    steps.append(
      try computeNumberOfSteps(
        startingAt: startNode, endingAt: { $0.position.suffix(fromBack: 1) == "Z" }, instruction,
        nodes))
  }
  return steps.reduce(1, { a, b in lcm(a, b) })
}
