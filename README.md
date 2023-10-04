# word-guesser
A word-guessing game with a grid interface. Players have attempts equal to the word length. It is written in Swift, calling into SDL2 C library bindings.

## Setup
* Package has been compiled and tested on Windows 11
* Install Swift toolchain. For Windows consult: https://www.swift.org/blog/swift-on-windows/
* Enable Developer mode from Settings
* Run `buildPackageWin.ps1` to get the vcpkg, pkgconf, C dependencies
* `swift run`
* Optional: Add more words in the words.txt file, they will be read at runtime and assigned to their corresponding grid.

# Controls
* Alphabetical input
* Backspace to remove characters
* Enter to progress to the next line
* Use `-` and `+` to change the grid size

## Demo
![](https://github.com/bgbernovici/word-guesser/blob/main/demo.gif)
