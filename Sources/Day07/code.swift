import Foundation
import Utils

public enum Card: Comparable {
  case joker, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

public protocol Hand: RowObject, Comparable {
  var type: Type { get }
  var cards: [Card] { get }
}

func compare<T: Hand>(_ lhs: T, _ rhs: T) -> Bool {
  if lhs.type < rhs.type {
    return true
  }
  if lhs.type > rhs.type {
    return false
  }
  for (lCard, rCard) in zip(lhs.cards, rhs.cards) {
    if lCard < rCard {
      return true
    }
    if lCard > rCard {
      return false
    }
  }
  print("----- HANDS ARE EQUAL -----")
  return true
}

public struct JokerHand: Hand {
  public static func < (lhs: JokerHand, rhs: JokerHand) -> Bool {
    return compare(lhs, rhs)
  }

  public static var regexp = try! NSRegularExpression(pattern: "^.{5}")

  public init(content: String) throws {
    cards = try content.map { char in
      try parseCard(char, jIs: .joker)
    }
  }
  public let cards: [Card]
}

public struct JackHand: Hand {
  public static func < (lhs: JackHand, rhs: JackHand) -> Bool {
    compare(lhs, rhs)
  }

  public static var regexp = try! NSRegularExpression(pattern: "^.{5}")

  public init(content: String) throws {
    cards = try content.map { char in
      try parseCard(char, jIs: .jack)
    }
  }

  public let cards: [Card]
}

func parseCard(_ char: String.Element, jIs: Card) throws -> Card {
  switch char {
  case "A":
    .ace
  case "K":
    .king
  case "Q":
    .queen
  case "J":
    jIs
  case "T":
    .ten
  case "9":
    .nine
  case "8":
    .eight
  case "7":
    .seven
  case "6":
    .six
  case "5":
    .five
  case "4":
    .four
  case "3":
    .three
  case "2":
    .two
  default:
    throw AocError.runtimeError("Bad input \(char)")
  }
}

public struct Bid: RowObject {
  public static var regexp = try! NSRegularExpression(pattern: "\\d+$")

  let bid: Int
  public init(content: String) throws {
    guard let bid = Int(content) else {
      throw AocError.runtimeError("Bad input \(content)")
    }
    self.bid = bid
  }
}

public struct JackPlay {
  let hand: JackHand
  let bid: Bid
}

public struct JokerPlay {
  let hand: JokerHand
  let bid: Bid
}

public struct Play<T: Hand> {
  let hand: T
  let bid: Bid
}

public enum Type: Comparable {
  case highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
}

extension JackHand {
  public var type: Type {
    let groupedCards = Dictionary(grouping: self.cards, by: { card in card })
    let cardCount = groupedCards.mapValues { $0.count }

    return determineType(cardCount)
  }
}

extension JokerHand {
  public var type: Type {
    let groupedCards = Dictionary(grouping: self.cards, by: { card in card })
    let cardCount = groupedCards.mapValues { $0.count }
    let jokerCount = cardCount[.joker] ?? 0
    if jokerCount == 5 {
      return .fiveOfAKind
    }
    var maximizedHand = cardCount.filter { $0.key != .joker }
    let largestGroup = maximizedHand.max { $0.value < $1.value }!
    maximizedHand.updateValue(largestGroup.value + jokerCount, forKey: largestGroup.key)

    return determineType(maximizedHand)
  }
}

func determineType(_ cardCount: [Card: Int]) -> Type {
  if cardCount.values.contains(5) {
    return .fiveOfAKind
  }
  if cardCount.values.contains(4) {
    return .fourOfAKind
  }
  if cardCount.values.contains(3) && cardCount.values.contains(2) {
    return .fullHouse
  }
  if cardCount.values.contains(3) {
    return .threeOfAKind
  }
  if cardCount.values.contains(2) && cardCount.count == 3 {
    return .twoPair
  }
  if cardCount.values.contains(2) {
    return .onePair
  }
  return .highCard
}

public func computeTotalWinnings<T: Hand>(_ input: [String], _ type: T.Type) -> Int {
  var plays: [Play<T>] = []
  for line in input {
    let hand = parseRowObjects(input: line, type: T.self)[0]
    let bid = parseRowObjects(input: line, type: Bid.self)[0]
    plays.append(Play(hand: hand, bid: bid))
  }

  let orderedPlays = plays.sorted(by: { $0.hand < $1.hand })
  var winnings = 0
  for (n, play) in orderedPlays.enumerated() {
    winnings += play.bid.bid * (n + 1)
  }
  return winnings
}
