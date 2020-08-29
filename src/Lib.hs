{-# LANGUAGE OverloadedStrings#-}
module Lib
    ( someFunc
    ) where


import Web.Scotty as Scotty
import System.Environment (getEnvironment)
import qualified Data.Text.Lazy as Text(pack, unpack, Text, toStrict, fromStrict)
--import Network.Download
import Control.Monad.Trans(liftIO, lift)
import Network.HTTP.Simple
import Data.ByteString.Lazy.Search
import qualified Data.ByteString.Lazy  as L(ByteString)
import qualified Data.ByteString as S(ByteString)


someFunc :: IO ()
someFunc = do
  env <- getEnvironment
  let port = maybe 8001 read $ lookup "PORT" env
  scotty port $ do
    get "/scrapbox/sitemap.xml" $ do
      req <- parseRequest "GET https://scrapbox.io/api/feed/ayu-mushi"
      res <- httpLBS req
      header "application/xml; charset=utf-8"
      raw $ replace ("scrapbox.io/ayu-mushi"::S.ByteString) ("ayu-mushi.herokuapp.com/scrapbox"::L.ByteString) $ getResponseBody res
    get "/scrapbox/:name" $ do
      name <- param "name"
      redirect $ Text.pack $ "http://scrapbox.io/ayu-mushi/" ++ name
      return ()