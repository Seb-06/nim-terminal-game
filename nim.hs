#!/usr/bin/env runhaskell
import System.Environment (getArgs)
import System.IO
import Data.Char (isDigit, digitToInt)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [sizeStr]
      | all isDigit sizeStr -> nimGame (read sizeStr)
      | otherwise -> putStrLn "Size must be a positive integer"
    _ -> putStrLn "Usage: ./Nim.hs <size>"

type Board = [Int]

clearBoard :: Int -> IO ()
clearBoard 0 = return ()
clearBoard n = do
  putStr "\ESC[1A"
  putStr "\ESC[2K"
  clearBoard (n - 1)

drawBoard :: Int -> Board -> IO ()
drawBoard player board = do
  putBoard 1 board
  putStrLn ("\nPlayer " ++ show player ++ ", enter your turn. format: <line>#<how many pieces>")
  putStrLn "Example: line 1 removing 2 pieces => 1#2"

putBoard :: Int -> Board -> IO ()
putBoard _ [] = return ()
putBoard n (x:xs) = do
  putStrLn (show n ++ ": " ++ replicate x '*')
  putBoard (n + 1) xs

refreshBoard :: Int -> Int -> Board -> IO ()
refreshBoard size player board = do
  clearBoard (size + 3)
  drawBoard player board

playerMove :: Board -> Int -> IO (Int, Int)
playerMove board player = do
  putStr ("Player " ++ show player ++ ": ")
  input <- getLine

  if validMove input
    then do
      putStr "\ESC[1A"
      putStr "\ESC[2K"
      return (toLine input, toCount input)
    else do
      putStr "\ESC[1A"
      putStr "\ESC[2K"
      putStr "Invalid move - "
      playerMove board player
  where
    validFormat [a, '#', c] = isDigit a && isDigit c
    validFormat _ = False

    toLine [a, '#', _] = digitToInt a
    toLine _ = 0

    toCount [_, '#', c] = digitToInt c
    toCount _ = 0

    validMove input =
      validFormat input &&
      let line = toLine input
          count = toCount input
          idx = line - 1
      in line >= 1 &&
         line <= length board &&
         count >= 1 &&
         count <= board !! idx

updateLine :: Int -> Int -> [Int] -> [Int]
updateLine _ _ [] = []
updateLine 0 new (_:xs) = new : xs
updateLine n new (x:xs) = x : updateLine (n - 1) new xs

nextPlayer :: Int -> Int
nextPlayer player = if player == 1 then 2 else 1

play :: Int -> Int -> Board -> IO ()
play size player board = do
  (line, n) <- playerMove board player
  let idx = line - 1
  let newVal = board !! idx - n
  let board' = updateLine idx newVal board

  if sum board' < 1
    then do
      clearBoard (size + 3)
      putStrLn ("Player " ++ show player ++ ", you won!")
    else do
      let player' = nextPlayer player
      refreshBoard size player' board'
      play size player' board'

nimGame :: Int -> IO ()
nimGame size =
  if size < 10
    then do
      putStrLn "\n____________________________________________________________"
      putStrLn "                          NIM Game                          "
      putStrLn "____________________________________________________________\n"
      let player = 1
      let board = [size, size - 1 .. 1]
      drawBoard player board
      play size player board
    else do
      putStrLn "board size must be less than 10"
      return ()
