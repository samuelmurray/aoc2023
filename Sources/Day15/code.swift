import Foundation
import Utils

func hash(_ input: any StringProtocol) -> Int {
  input.reduce(0, { hash, c in (hash + Int(c.asciiValue!)) * 17 % 256 })
}

func computeSum1(_ input: [String]) throws -> Int {
  if input.count != 1 {
    throw AocError.runtimeError("Unexpected length: \(input.count)")
  }
  return input[0].split(separator: ",").map { hash($0) }.reduce(0, +)
}

struct Lens: Hashable {
  let label: String
  let focalLength: Int
}

func computeSum2(_ input: [String]) throws -> Int {
  if input.count != 1 {
    throw AocError.runtimeError("Unexpected length: \(input.count)")
  }
  var boxes: [Int: [Lens]] = [:]
  for i in 0..<256 {
    boxes[i] = []
  }
  for operation in input[0].split(separator: ",") {
    let indexOfOpChar = operation.firstIndex(where: { $0 == "=" || $0 == "-" })!
    let label = operation[operation.startIndex..<indexOfOpChar]
    let opChar = operation[indexOfOpChar]
    let boxIdx = hash(label)
    var box = boxes[boxIdx]!
    if opChar == "=" {
      let lens = Lens(
        label: String(label),
        focalLength: Int(operation.suffix(from: operation.index(indexOfOpChar, offsetBy: 1)))!)
      if let idx = box.firstIndex(where: { $0.label == label }) {
        box[idx] = lens
      } else {
        box.append(lens)
      }
    } else if opChar == "-" {
      box.removeAll(where: { $0.label == label })
    } else {
      throw AocError.runtimeError("Unexpected char: \(opChar)")
    }
    boxes[boxIdx] = box
  }
  return boxes.map { box, lenses in
    lenses.enumerated().map { (slot, lens) in
      (box + 1) * (slot + 1) * lens.focalLength
    }.reduce(0, +)
  }.reduce(0, +)
}
