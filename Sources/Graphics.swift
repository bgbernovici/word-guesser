import SDL

class Graphics {

  var renderer: OpaquePointer?

  init(renderer: OpaquePointer?) {
    self.renderer = renderer
  }

  func drawQuadBezier(
    x0: Int32, y0: Int32, x1: Int32, y1: Int32, x2: Int32, y2: Int32, t: Double
  ) -> (Int32, Int32) {

    let t1 = 1 - t
    let t2 = (t1 * Double(x0)) + (t * Double(x1))
    let t3 = (t1 * Double(x1)) + (t * Double(x2))
    let x: Int32 = Int32((t1 * t2) + (t * t3))

    let t4 = 1 - t
    let t5 = (t4 * Double(y0)) + (t * Double(y1))
    let t6 = (t4 * Double(y1)) + (t * Double(y2))
    let y: Int32 = Int32((t4 * t5) + (t * t6))

    return (x, y)
  }

  func drawCubicBezier(
    x0: Int32, y0: Int32, x1: Int32, y1: Int32, x2: Int32, y2: Int32, x3: Int32, y3: Int32,
    steps: Int
  ) {
    for t in stride(from: 0.0, to: 1.0, by: 1.0 / Double(steps)) {
      let (leftQuadX, leftQuadY) = drawQuadBezier(
        x0: x0, y0: y0, x1: x1, y1: y1, x2: x2, y2: y2, t: t)
      let (rightQuadX, rightQuadY) = drawQuadBezier(
        x0: x1, y0: y1, x1: x2, y1: y2, x2: x3, y2: y3, t: t)

      let t1 = 1 - t
      let t2 = t1 * Double(leftQuadX)
      let t3 = t * Double(rightQuadX)
      let x: Int32 = Int32(t2 + t3)

      let t5 = t1 * Double(leftQuadY)
      let t6 = t * Double(rightQuadY)
      let y: Int32 = Int32(t5 + t6)
      SDL_RenderDrawPoint(renderer, x, y)
    }
  }

  func drawLetter(
    letter: Character, startX: Int32, startY: Int32, size: Int32
  ) {
    let localX = startX + size / 4
    let localY = startY + size / 4
    let localSize = size / 2
    switch letter {
    case "A":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize, localX + localSize / 2, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 4, localY + localSize / 2,
        (localX + localSize) - localSize / 4,
        localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY, localX + localSize, localY + localSize)
    case "B":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize / 2)
      drawCubicBezier(
        x0: localX,
        y0: localY,
        x1: localX + localSize,
        y1: localY,
        x2: localX + localSize,
        y2: localY + localSize / 2,
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX, localY + localSize)
      drawCubicBezier(
        x0: localX,
        y0: localY + localSize / 2,
        x1: localX + localSize,
        y1: localY + localSize / 2,
        x2: localX + localSize,
        y2: localY + localSize,
        x3: localX,
        y3: localY + localSize, steps: 100)
    case "C":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY + localSize / 4,
        x1: localX + localSize / 2,
        y1: localY,
        x2: localX,
        y2: localY + localSize / 4,
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY + localSize - (localSize / 4),
        x1: localX + localSize / 2,
        y1: localY + localSize,
        x2: localX,
        y2: localY + localSize - (localSize / 4),
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
    case "D":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      drawCubicBezier(
        x0: localX,
        y0: localY,
        x1: localX + localSize,
        y1: localY + localSize / 4,
        x2: localX + localSize,
        y2: localY + localSize - (localSize / 4),
        x3: localX,
        y3: localY + localSize, steps: 100)
    case "E":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX + localSize, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize, localX + localSize, localY + localSize)
    case "F":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX + localSize, localY + localSize / 2)
    case "G":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      drawLetter(
        letter: "C", startX: startX, startY: startY, size: size)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize / 2, localX + localSize,
        localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY + localSize / 2, localX + localSize,
        localY + localSize - (localSize / 4))
    case "H":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX + localSize, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX + localSize, localY + localSize)
    case "I":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY, localX + localSize / 2, localY + localSize)
    case "J":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY, localX + localSize / 2,
        localY + (localSize - localSize / 3))
      drawCubicBezier(
        x0: localX + localSize / 2,
        y0: localY + (localSize - localSize / 3),
        x1: localX + localSize / 2,
        y1: localY + localSize,
        x2: localX + localSize / 4,
        y2: localY + localSize,
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
    case "K":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX + localSize, localY + localSize)
    case "L":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize, localX + localSize, localY + localSize)
    case "M":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize / 2, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize / 2, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX + localSize, localY + localSize)
    case "N":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX + localSize, localY + localSize)
    case "O":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY + localSize / 2,
        x1: localX + localSize,
        y1: localY,
        x2: localX,
        y2: localY,
        x3: localX,
        y3: localY + localSize / 2, steps: 200)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY + localSize / 2,
        x1: localX + localSize,
        y1: localY + localSize,
        x2: localX,
        y2: localY + localSize,
        x3: localX,
        y3: localY + localSize / 2, steps: 200)
    case "P":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize)
      drawCubicBezier(
        x0: localX,
        y0: localY,
        x1: localX + localSize,
        y1: localY,
        x2: localX + localSize,
        y2: localY + localSize / 2,
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
    case "Q":
      drawLetter(
        letter: "O", startX: startX, startY: startY, size: size)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize / 2, localX + localSize,
        localY + localSize)
    case "R":
      drawLetter(
        letter: "P", startX: startX, startY: startY, size: size)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize / 2, localX + localSize, localY + localSize)
    case "S":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY,
        x1: localX,
        y1: localY,
        x2: localX,
        y2: localY + localSize / 2,
        x3: localX + localSize / 2,
        y3: localY + localSize / 2, steps: 100)
      drawCubicBezier(
        x0: localX,
        y0: localY + localSize,
        x1: localX + localSize,
        y1: localY + localSize,
        x2: localX + localSize,
        y2: localY + localSize / 2,
        x3: localX + localSize / 2,
        y3: localY + localSize / 2, steps: 100)
    case "T":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY, localX + localSize / 2, localY + localSize)
    case "U":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX + localSize, localY + localSize / 2)
      drawCubicBezier(
        x0: localX + localSize,
        y0: localY + localSize / 2,
        x1: localX + localSize,
        y1: localY + localSize,
        x2: localX,
        y2: localY + localSize,
        x3: localX,
        y3: localY + localSize / 2, steps: 100)
    case "V":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize / 2, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize, localX + localSize, localY)
    case "W":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize / 3, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 3, localY + localSize, localX + localSize / 2, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY, localX + localSize - localSize / 3,
        localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX + localSize - localSize / 3, localY + localSize, localX + localSize, localY
      )
    case "X":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize, localX + localSize, localY)
    case "Y":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize / 2, localY + localSize / 2)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize / 2, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize / 2, localY + localSize / 2, localX + localSize / 2,
        localY + localSize)
    case "Z":
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 1)
      SDL_RenderDrawLine(
        renderer, localX, localY, localX + localSize, localY)
      SDL_RenderDrawLine(
        renderer, localX + localSize, localY, localX, localY + localSize)
      SDL_RenderDrawLine(
        renderer, localX, localY + localSize, localX + localSize,
        localY + localSize)
    default:
      break
    }
  }
}
