import System.FilePath
import System.Directory
import System.Process
import System.IO
import System.Environment
import Control.Concurrent

main = do
	args <- getArgs

	let (envdir, command) = (head args, tail args)
	files <- getDirectoryContents envdir

	let envFiles = [ joinPath [envdir, fp] | fp <- files, validEnvFile fp ] 
	printEnvDirContent envFiles
	printFileContent $ head envFiles
	(_, _, _, handle) <- createProcess(proc (head command) (tail command))
	waitForProcess handle

printEnvDirContent :: [FilePath] -> IO ()
printEnvDirContent files = do
	print files

validEnvFile :: FilePath -> Bool
validEnvFile = not . hasExtension 

printFileContent :: FilePath -> IO ()
printFileContent fp = readFile fp >>= putStr