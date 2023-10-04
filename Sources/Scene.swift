import SDL

class Scene {
  var gap = 2
  var startX = 200
  var startY = 100
  var toX = 600
  var toY = 500
  var logic: Logic
  var renderer: OpaquePointer?
  var graphics: Graphics
  var event = SDL_Event()

  var width: Int {
    return toX - startX
  }

  var height: Int {
    return toY - startY
  }

  var totalGap: Int {
    return gap * (logic.boxes - 1)
  }

  var effectiveWidth: Int {
    return width - totalGap
  }

  var effectiveHeight: Int {
    return height - totalGap
  }

  var stepX: Int {
    return width / logic.boxes + gap
  }

  var stepY: Int {
    return height / logic.boxes + gap
  }

  var tileWidth: Int {
    return effectiveWidth / logic.boxes
  }

  var tileHeight: Int {
    return effectiveHeight / logic.boxes
  }

  init(logic: Logic, renderer: OpaquePointer?) {
    self.logic = logic
    self.renderer = renderer
    self.graphics = Graphics(renderer: renderer)
  }

  func drawGrid(startX: Int, toX: Int, startY: Int, toY: Int, tileWidth: Int, tileHeight: Int) {
    var k = 0
    var g = 0
    for i in stride(from: startX, to: toX, by: stepX) {
      defer { k += 1 }
      defer { g = 0 }

      for j in stride(from: startY, to: toY, by: stepY) {
        defer { g += 1 }
        var tile = SDL_Rect(
          x: Int32(i), y: Int32(j), w: Int32(tileWidth), h: Int32(tileHeight))
        SDL_SetRenderDrawColor(renderer, 211, 214, 218, 1)
        SDL_RenderFillRect(renderer, &tile)
        guard let letter = logic.m[k][g] else {
          continue
        }

        switch logic.gameState {
        case .REACHED_ENDING_AND_LOST:
          break
        case .REACHED_ENDING_AND_WON:
          break
        case .SUSPEND:
          break
        case .PLAYING, .ENDING:
          if logic.level > g || logic.gameState == .ENDING {
            let comparison = logic.compareWords(comparedLevel: g)

            if comparison[k] == "M" {
              SDL_SetRenderDrawColor(renderer, 106, 170, 100, 1)
              SDL_RenderFillRect(renderer, &tile)
            } else if comparison[k] == "O" {
              SDL_SetRenderDrawColor(renderer, 201, 180, 88, 1)
              SDL_RenderFillRect(renderer, &tile)
            } else {
              SDL_SetRenderDrawColor(renderer, 95, 99, 101, 1)
              SDL_RenderFillRect(renderer, &tile)
            }
          } else {
            SDL_SetRenderDrawColor(renderer, 120, 124, 126, 1)
            SDL_RenderFillRect(renderer, &tile)
          }
        case .RUNNING_ANIMATION:
          if letter == "1" {
            SDL_SetRenderDrawColor(renderer, 106, 170, 100, 1)
            SDL_RenderFillRect(renderer, &tile)
          } else if letter == "0" {
            SDL_SetRenderDrawColor(renderer, 220, 20, 60, 1)
            SDL_RenderFillRect(renderer, &tile)
          } else {
            SDL_SetRenderDrawColor(renderer, 95, 99, 101, 1)
            SDL_RenderFillRect(renderer, &tile)
          }
        }
        graphics.drawLetter(
          letter: letter, startX: Int32(i), startY: Int32(j), size: Int32(tileWidth))
      }
    }
  }

  func render() {
    if logic.gameState != .SUSPEND {
      drawGrid(
        startX: startX, toX: toX, startY: startY, toY: toY, tileWidth: tileWidth,
        tileHeight: tileHeight
      )
    }

    while SDL_PollEvent(&event) > 0 {
      switch event.type {
      case Uint32(SDL_QUIT.rawValue):
        logic.quit = true
      case Uint32(SDL_MOUSEBUTTONDOWN.rawValue):
        break
      case Uint32(SDL_KEYDOWN.rawValue):
        if logic.gameState == .PLAYING {
          if (event.key.keysym.sym >= 65 && event.key.keysym.sym <= 90)
            || (event.key.keysym.sym >= 97 && event.key.keysym.sym <= 122)
          {
            var string = ""
            string.append(Character(UnicodeScalar(UInt8(event.key.keysym.sym))))
            logic.addLetter(letter: Character(string.uppercased()))
          }
          if event.key.keysym.sym == 8 {
            logic.deleteLetter()
          }
          if event.key.keysym.sym == 13 {
            logic.progress()
          }
          if event.key.keysym.sym == 61 {
            logic.gameState = .SUSPEND
            logic.boxes = min(10, logic.boxes + 1)
            logic.resetWhenBoxesChange()
          }
          if event.key.keysym.sym == 45 {
            logic.gameState = .SUSPEND
            logic.boxes = max(4, logic.boxes - 1)
            logic.resetWhenBoxesChange()
          }
          if event.key.keysym.sym == 9 {
            logic.quit = true
          }
        }
        break
      default:
        break
      }
    }
  }
}
