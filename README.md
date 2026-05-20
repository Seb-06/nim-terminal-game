# Nim Terminal Game
### Just a small haskell script that implements a simple Nim game within the terminal

## Requirements

Install Haskell using GHCup:
- https://www.haskell.org/ghcup/
- https://www.haskell.org/get-started/

## Setup

### Linux / macOS

Add permissions to run script directly:

```zsh
chmod +x Nim.hs
```

Or run with runhaskell:

```zsh
runhaskell Nim.hs <board-size>
```

### Windows
Run with runhaskell:

```powershell
runhaskell Nim.hs <board-size>
```

## Usage
```zsh
./Nim.hs <size>
```

Example:

```zsh
./Nim.hs 5
```

The game does not accept any sizes above 9

![Demo](./assets/demo.gif)
