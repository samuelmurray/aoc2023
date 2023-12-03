import Utils
import XCTest

class UtilsTests: XCTestCase {
  func testSuffixFrom0() {
    XCTAssertEqual("abc", "abc".suffix(from: 0))
  }

  func testSuffixFromIndex() {
    XCTAssertEqual("c", "abc".suffix(from: 2))
  }

  func testSuffixFromEnd() {
    XCTAssertEqual("", "abc".suffix(from: 3))
  }

  func testFirstNumber() {
    let digits = try! Regex("([0-9]+)")
    let match = try? digits.firstMatch(in: "467..114..")
    XCTAssertEqual("467", match?.0)
  }
}
