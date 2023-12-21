import Algorithms
import Collections

// State : a protocole for states in the search space
public protocol State: Hashable, Comparable {

  // successors() : returns an array of successors states in the search space
  func successors() -> [Successor<Self>]

  // heuristic(goal) : returns the heuristic value in relation to a given goal state
  func heuristic(_ goal: Self) -> Int

  // id : a string identifying a state
  var id: String { get }

  func isAt(_ goal: Self) -> Bool
}

// Successor : represents a successor state and its cost
public struct Successor<T: State> {
  public let state: T
  let cost: Int

  public init(state: T, cost: Int) {
    self.state = state
    self.cost = cost
  }
}

public struct WeightedState<T: State>: Comparable {
  let state: T
  let fScore: Int

  public static func < (lhs: WeightedState, rhs: WeightedState) -> Bool {
    return lhs.fScore < rhs.fScore
  }
}

// AStar<TState> : finds the A* solution (nil if no solution found) given a start state and goal state
public func AStar<TState: State>(start: [TState], goal: TState) -> (path: [TState], cost: Int)? {
  var visitedNodes = Set<TState>()
  var openSet = Heap<WeightedState<TState>>()
  start.forEach { openSet.insert(WeightedState(state: $0, fScore: $0.heuristic(goal))) }

  var cameFrom: [TState: TState] = [:]

  var gScores: [TState: Int] = [:]
  start.forEach { gScores[$0] = 0 }

  var fScores: [TState: Int] = [:]
  start.forEach { fScores[$0] = $0.heuristic(goal) }

  while !openSet.isEmpty {
    let current = openSet.popMin()!.state
    visitedNodes.remove(current)
    guard !current.isAt(goal) else {
      return (reconstructPath(current, cameFrom), gScores[current]!)
    }

    let successors = current.successors()
    for successor in successors {
      let tenativeGScore = gScores[current]! + successor.cost
      if tenativeGScore < gScores[successor.state] ?? 9_999_999 {
        cameFrom[successor.state] = current
        gScores[successor.state] = tenativeGScore
        fScores[successor.state] = tenativeGScore + successor.state.heuristic(goal)
        if !visitedNodes.contains(successor.state) {
          visitedNodes.insert(successor.state)
          openSet.insert(WeightedState(state: successor.state, fScore: fScores[successor.state]!))
        }
      }
    }
  }
  return nil
}

func reconstructPath<TState: State>(_ last: TState, _ cameFrom: [TState: TState]) -> [TState] {
  var path = [last]
  var current = last
  while let previous = cameFrom[current] {
    current = previous
    path.append(current)
  }
  return path.reversed()
}
