import Dispatch

import Foundation

class Logic {
  var chosenWords: [Int: [String]] = [:]
  var boxes = 8
  var level: Int = 0
  var gameState: GameState = .PLAYING
  var m: [[Character?]]
  var quit = false
  var chosenWord: String = "STARSHIP"

  init() {
    self.m = [[Character?]](
      repeating: [Character?](repeating: nil, count: boxes),
      count: boxes
    )
    readWordsFile()
    self.chosenWord = chosenWords[boxes]![Int.random(in: 0..<chosenWords[boxes]!.count)]
  }

  func readWordsFile() {
    if let fileContents = try? String(contentsOfFile: "words.txt") {
      let words = fileContents.components(separatedBy: .newlines)
      for word in words {
        if word.count >= 4 && word.count <= 10 {
          if chosenWords[word.count] != nil {
            chosenWords[word.count]!.append(word.uppercased())
          } else {
            chosenWords[word.count] = [word.uppercased()]
          }
        }
      }
    } else {
      print("Failed to read the file.")
    }
  }

  func addLetter(letter: Character) {
    for i in 0...boxes - 1 {
      if m[i][level] == nil {
        m[i][level] = letter
        break
      }
    }
  }

  func deleteLetter() {
    for i in (0...boxes - 1).reversed() {
      if m[i][level] != nil {
        m[i][level] = nil
        break
      }
    }
  }

  func progress() {
    var full = true
    var reconstructed: String = ""
    for i in (0...boxes - 1).reversed() {
      if m[i][level] == nil {
        full = false
      } else {
        reconstructed.append(m[i][level]!)
      }
    }
    if full {
      let reversedReconstructed = String(reconstructed.reversed())
      guard chosenWords[boxes]!.contains(reversedReconstructed) else {
        return
      }
      check()
      level = min(level + 1, boxes - 1)
    }
  }

  func check() {
    var won: Bool = true
    for i in (0...boxes - 1) {
      let index = chosenWord.index(chosenWord.startIndex, offsetBy: i)
      if m[i][level] != chosenWord[index] {
        won = false
      }
    }

    if won {
      gameState = .ENDING
      DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        self.gameState = GameState.REACHED_ENDING_AND_WON
        self.playEndingAnimation()

      }
    } else {
      if self.level == self.boxes - 1 {
        gameState = .ENDING
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
          self.gameState = GameState.REACHED_ENDING_AND_LOST
          self.playEndingAnimation()
        }
      }
    }
  }

  func playEndingAnimation() {
    switch gameState {
    case .REACHED_ENDING_AND_WON:
      gameState = .RUNNING_ANIMATION
      var seconds = 0.05
      for i in (0...boxes - 1) {
        for j in (0...boxes - 1) {
          seconds += 0.05
          DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            self.m[i][j] = "1"
          }
        }
      }
      for i in (0...boxes - 1) {
        for j in (0...boxes - 1) {
          seconds += 0.05
          DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            self.m[i][j] = nil
          }
        }
      }
      DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
        self.level = 0
        self.chosenWord =
          self.chosenWords[self.boxes]![Int.random(in: 0..<self.chosenWords[self.boxes]!.count)]
        self.gameState = .PLAYING
      }
    case .REACHED_ENDING_AND_LOST:
      gameState = .RUNNING_ANIMATION
      var seconds = 0.05
      for i in (0...boxes - 1).reversed() {
        for j in (0...boxes - 1).reversed() {
          seconds += 0.05
          DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            self.m[i][j] = "0"
          }
        }
      }
      for i in (0...boxes - 1).reversed() {
        for j in (0...boxes - 1).reversed() {
          seconds += 0.05
          DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            self.m[i][j] = nil
          }
        }
      }
      DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
        self.level = 0
        self.chosenWord =
          self.chosenWords[self.boxes]![Int.random(in: 0..<self.chosenWords[self.boxes]!.count)]
        self.gameState = .PLAYING
      }
    case .PLAYING:
      return
    default:
      return
    }
  }

  func resetWhenBoxesChange() {
    m = [[Character?]](
      repeating: [Character?](repeating: nil, count: boxes),
      count: boxes
    )
    level = 0
    self.chosenWord = chosenWords[boxes]![Int.random(in: 0..<chosenWords[boxes]!.count)]
    gameState = .PLAYING
  }

  func compareWords(comparedLevel: Int) -> [Character] {
    /** 
      M -> matches
      O -> occurs
      X -> no occurence or match
    **/
    var occurences: [Character: Int] = [:]
    var comparison = [Character](repeating: "X", count: chosenWord.count)

    for c in chosenWord {
      if occurences.contains(where: { key, _ in key == c }) {
        occurences[c]! += 1
      } else {
        occurences[c] = 1
      }
    }

    //Look for matches
    for i in 0...chosenWord.count - 1 {
      let index = chosenWord.index(chosenWord.startIndex, offsetBy: i)
      if chosenWord[index] == m[i][comparedLevel], occurences[chosenWord[index]]! > 0 {
        occurences[chosenWord[index]]! -= 1
        comparison[i] = "M"
      }
    }
    //Look for occurences
    for i in 0...chosenWord.count - 1 {
      if chosenWord.contains(m[i][comparedLevel] ?? "."), comparison[i] != "M" {
        if let c = m[i][comparedLevel], occurences[c]! > 0 {
          occurences[c]! -= 1
          comparison[i] = "O"
        }
      }
    }
    return comparison
  }
}
