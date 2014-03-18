import System.FilePath
import System.Directory
import System.Process
import System.IO
import System.Environment
import System.Exit
import System.Posix.Env
import Control.Concurrent

main = do
	args <- getArgs

	let (envdir, command) = (head args, tail args)
	files <- getDirectoryContents envdir

	let envFiles = [ joinPath [envdir, fp] | fp <- files, validEnvFile fp ] 
	exportEnv envFiles
	(_, _, _, handle) <- createProcess $ proc (head command) (tail command) 
	_ <- waitForProcess handle
	exitSuccess


validEnvFile :: FilePath -> Bool
validEnvFile = not . hasExtension 

exportEnv :: [FilePath] -> IO ()
exportEnv = mapM_ (\key -> readFile key >>= (\val -> putEnv $ takeFileName key ++ "=" ++ val))