import Day07
import Utils
import XCTest

class Day07Tests: XCTestCase {
  func testJackHand() throws {
    let hand = try JackHand(content: "32T3J")

    XCTAssertEqual([Card.three, .two, .ten, .three, .jack], hand.cards)
  }

  func testJokerHand() throws {
    let hand = try JokerHand(content: "32T3J")

    XCTAssertEqual([Card.three, .two, .ten, .three, .joker], hand.cards)
  }

  func testHandType() throws {
    let hand = try JackHand(content: "32T3K")

    XCTAssertEqual(Type.onePair, hand.type)
  }

  func testHandTypeJack() throws {
    let hand = try JackHand(content: "T55J5")

    XCTAssertEqual(Type.threeOfAKind, hand.type)
  }

  func testHandTypeJoker() throws {
    let hand = try JokerHand(content: "T55J5")

    XCTAssertEqual(Type.fourOfAKind, hand.type)
  }

  func testHandComparisonDifferentTypes() throws {
    let hand1 = try JackHand(content: "33332")
    let hand2 = try JackHand(content: "22222")

    XCTAssertLessThan(hand1, hand2)
  }

  func testHandComparisonSameType() throws {
    let hand1 = try JackHand(content: "33332")
    let hand2 = try JackHand(content: "2AAAA")

    XCTAssertGreaterThan(hand1, hand2)
  }

  func testGivenInput1() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeTotalWinnings(input, JackHand.self)

    XCTAssertEqual(6440, result)
  }

  func testUnknownInput1() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeTotalWinnings(input, JackHand.self)

    print(result)
  }

  func testGivenInput2() throws {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeTotalWinnings(input, JokerHand.self)

    XCTAssertEqual(5905, result)
  }

  func testUnknownInput2() throws {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = try readFile(filePath)

    let result = computeTotalWinnings(input, JokerHand.self)

    print(result)
  }
}
