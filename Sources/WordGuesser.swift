import SDL

class WordGuesserGame {
  private var renderer: OpaquePointer?
  private var window: OpaquePointer?

  private var logic: Logic = Logic()
  private var scene: Scene

  init() {
    guard SDL_Init(SDL_INIT_VIDEO) == 0 else {
      fatalError("SDL could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
    }
    let win = SDL_CreateWindow(
      "Word Guesser",
      Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
      800, 600,
      UInt32(SDL_WINDOW_SHOWN.rawValue))
    let ren = SDL_CreateRenderer(win, -1, UInt32(SDL_RENDERER_ACCELERATED.rawValue))
    self.window = win
    self.renderer = ren
    self.scene = Scene(logic: logic, renderer: ren)
  }

  deinit {
    SDL_DestroyRenderer(renderer)
    SDL_DestroyWindow(window)
    SDL_Quit()
  }

  func run() {
    while !logic.quit {
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255)
      SDL_RenderClear(renderer)

      scene.render()

      SDL_RenderPresent(renderer)
      SDL_Delay(100)
    }
  }
}
