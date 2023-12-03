import Day01
import Utils
import XCTest

class Day01Tests: XCTestCase {
  func test1_1() {
    let output = getNumber("1abc2")

    XCTAssertEqual(12, output)
  }

  func test1_2() {
    let output = getNumber("pqr3stu8vwx")

    XCTAssertEqual(38, output)
  }

  func test1_3() {
    let output = getNumber("a1b2c3d4e5f")

    XCTAssertEqual(15, output)
  }

  func test1_4() {
    let output = getNumber("treb7uchet")

    XCTAssertEqual(77, output)
  }

  func testComputeSum() {
    let filePath = Bundle.module.url(forResource: "test-input1", withExtension: "txt")!
    let input = readFile(filePath)
    let output = computeSum(input)
    XCTAssertEqual(142, output)
  }

  func testConvertsSpelledDigitsToNumbers() {
    let input = "nine"
    let output = replaceTextWithDigits(input)
    XCTAssertEqual("9", output)
  }

  func test2_1() {
    XCTAssertEqual(29, getNumber(replaceTextWithDigits("two1nine")))
    XCTAssertEqual(83, getNumber(replaceTextWithDigits("eightwothree")))
    XCTAssertEqual(13, getNumber(replaceTextWithDigits("abcone2threexyz")))
    XCTAssertEqual(24, getNumber(replaceTextWithDigits("xtwone3four")))
    XCTAssertEqual(42, getNumber(replaceTextWithDigits("4nineeightseven2")))
    XCTAssertEqual(14, getNumber(replaceTextWithDigits("zoneight234")))
    XCTAssertEqual(76, getNumber(replaceTextWithDigits("7pqrstsixteen")))
  }

  func testComputeSumWithText() {
    let filePath = Bundle.module.url(forResource: "test-input2", withExtension: "txt")!
    let input = readFile(filePath)
    let output = computeSum(input)
    XCTAssertEqual(281, output)
  }

  func testProper() {
    let filePath = Bundle.module.url(forResource: "input1", withExtension: "txt")!
    let input = readFile(filePath)
    print(computeSum(input))
  }

  func test2() {
    let filePath = Bundle.module.url(forResource: "input2", withExtension: "txt")!
    let input = readFile(filePath)
    print(computeSum(input))
  }

  func testReplacePrefix1() {
    let (prefix, suffix) = replacePrefixWithDigit("zerozero")
    XCTAssertEqual("0", prefix)
    XCTAssertEqual("zero", suffix)
  }

  func testReplacePrefix2() {
    let (prefix, suffix) = replacePrefixWithDigit("onezero")
    XCTAssertEqual("1", prefix)
    XCTAssertEqual("zero", suffix)
  }
  func testReplacePrefix3() {
    let (prefix, suffix) = replacePrefixWithDigit("onzero")
    XCTAssertEqual("o", prefix)
    XCTAssertEqual("nzero", suffix)
  }

  func testReplaceText1() {
    let output = replaceTextWithDigits("onezero")
    XCTAssertEqual("10", output)
  }

  func testReplaceText2() {
    let output = replaceTextWithDigits("zerozero")
    XCTAssertEqual("00", output)
  }

  func testReplaceText3() {
    let output = replaceTextWithDigits("onzero")
    XCTAssertEqual("on0", output)
  }
}
