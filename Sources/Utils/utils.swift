import Foundation

public enum AocError: Error {
  case runtimeError(String)
}

public func readFile(_ fileName: String) throws -> [String] {
  let filePath = URL(fileURLWithPath: fileName)
  return try readFile(filePath)
}

public func readFile(_ url: URL) throws -> [String] {
  let content = try String(contentsOf: url.absoluteURL, encoding: .utf8)
  var result: [String] = []
  content.enumerateLines { (line, _) -> Void in
    result.append(line)
  }
  return result
}

extension StringProtocol {
  public subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
}

extension String {
  public func suffix(from: Int) -> String {
    return String(self.suffix(from: self.index(self.startIndex, offsetBy: from)))
  }

  public func suffix(fromBack: Int) -> String {
    return String(self.suffix(1))
  }

  public func groups(_ regexp: NSRegularExpression) -> [[String]] {
    do {
      let text = self
      let matches = regexp.matches(
        in: text,
        range: NSRange(text.startIndex..., in: text))
      return matches.map { match in
        return (0..<match.numberOfRanges).map {
          let rangeBounds = match.range(at: $0)
          guard let range = Range(rangeBounds, in: text) else {
            return ""
          }
          return String(text[range])
        }
      }
    }
  }
}

extension Array where Element == String {
  public func transposed() -> [String] {
    var transposed: [String] = []
    for x in 0..<self[0].count {
      transposed.append(self.map { String($0[x]) }.joined())
    }
    return transposed
  }
}

extension Array {
  public init(repeating: [Element], count: Int, separator: Element? = nil) {
    self.init([[Element]](repeating: repeating, count: count).flatMap { $0 })
  }

  public func repeated(count: Int, separator: Element? = nil) -> [Element] {
    return [Element](repeating: self, count: count, separator: separator)
  }
}

public func lcm(_ a: Int, _ b: Int) -> Int {
  return abs(a * b) / gcd(a, b)
}

public func gcd(_ a: Int, _ b: Int) -> Int {
  return b == 0 ? a : gcd(b, a % b)
}

public func parseRowObjects<T: RowObject>(input: String, type: T.Type) -> [T] {
  var result: [T] = []
  let matches = type.regexp.matches(in: input, range: NSRange(location: 0, length: input.count))
  for match in matches {
    let content = String(input[Range(match.range, in: input)!])
    result.append(
      try! T(content: content)
    )
  }
  return result
}

public func parsePositionalRowObjects<T: PositionalRowObject>(
  input: String, rowNumber: Int, type: T.Type
) -> [T] {
  var result: [T] = []
  let matches = type.regexp.matches(in: input, range: NSRange(location: 0, length: input.count))
  for match in matches {
    let content = String(input[Range(match.range, in: input)!])
    let startPosition = match.range.location
    let length = match.range.length
    result.append(
      try! T(row: rowNumber, startPosition: startPosition, length: length, content: content))
  }
  return result
}

public protocol RowObject {
  static var regexp: NSRegularExpression { get }
  init(content: String) throws
}

public protocol PositionalRowObject {
  static var regexp: NSRegularExpression { get }
  var row: Int { get }
  var startPosition: Int { get }
  var length: Int { get }
  init(row: Int, startPosition: Int, length: Int, content: String) throws
}

extension PositionalRowObject {
  public func adjacent(other: PositionalRowObject) -> Bool {
    return (self.row >= other.row - 1 && self.row <= other.row + 1)
      && (self.endPosition >= other.startPosition - 1
        && self.startPosition <= other.endPosition + 1)
  }

  public var endPosition: Int { startPosition + length - 1 }
}
