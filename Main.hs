import Snap.Core
import Snap.Http.Server
import System.Environment
import Control.Applicative
import Snap.Util.FileServe

main :: IO ()
main = do
    env <- getEnvironment
    let port = maybe 8080 read $ lookup "PORT" env
        config = setPort port
               . setAccessLog ConfigNoLog
               . setErrorLog ConfigNoLog
               $ defaultConfig
    httpServe config (
      ifTop ( writeBS "Hello, world!" ) <|>
      route [ ("foo", writeBS "bar")
            , ("echo/:echoparam", echoHandler)
            ] <|>
      dir "static" (serveDirectory "."))

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param

