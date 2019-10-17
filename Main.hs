module Main where

import System.Process
import Control.Monad
import Control.Concurrent
import System.Posix.Files
import System.Posix.Time

codeFp = "~/sclangOuts/code.txt"
postFp = "~/sclangOuts/post.txt"
freqTime = (60 * 5)

main :: IO ()
main = do
  forever checkAndSendData 
  return ()

checkAndSendData = do
  u <- updated
  if u
  then sendData codeFp >> sendData postFp 
  else return ()
  threadDelay $ (1000 * 1000) * (floor $ toRational freqTime)

updated :: IO Bool
updated = do
  cModTime <- getFileStatus codeFp >>= return. modificationTime 
  now <- epochTime
  print cModTime
  print now
  print $ (now - freqTime) < cModTime
  return $ (now - freqTime) < cModTime

sendData fp = do
  r <- createProcess $ shell ("AWS_ACCESS_KEY_ID=AKIA45JS5AJSAH64ZBUW AWS_SECRET_ACCESS_KEY=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 aws s3 cp " ++ fp ++ " s3://sclang/")
  return ()
