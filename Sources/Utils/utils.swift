import Foundation

public func readFile(_ fileName: String) -> [String] {
    let filePath = URL(fileURLWithPath: fileName)
    let content = try! String(contentsOf: filePath.absoluteURL, encoding: .utf8)
    var result: [String] = []
    content.enumerateLines { (line, _) -> () in
        result.append(line)
    }
    return result
}

public extension String {
    func suffix(from: Int) -> String {
        return String(self.suffix(from: self.index(self.startIndex, offsetBy: from)))
    }
}