import Foundation

public enum AocError: Error {
  case runtimeError(String)
}

public func readFile(_ fileName: String) -> [String] {
  let filePath = URL(fileURLWithPath: fileName)
  return readFile(filePath)
}

public func readFile(_ url: URL) -> [String] {
  let content = try! String(contentsOf: url.absoluteURL, encoding: .utf8)
  var result: [String] = []
  content.enumerateLines { (line, _) -> Void in
    result.append(line)
  }
  return result
}

extension String {
  public func suffix(from: Int) -> String {
    return String(self.suffix(from: self.index(self.startIndex, offsetBy: from)))
  }
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

public extension PositionalRowObject {
  func adjacent(other: PositionalRowObject) -> Bool {
    return (self.row >= other.row - 1 && self.row <= other.row + 1)
      && (self.endPosition >= other.startPosition - 1
        && self.startPosition <= other.endPosition + 1)
  }

  var endPosition: Int { startPosition + length - 1 }
}
