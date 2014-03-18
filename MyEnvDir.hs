import System.FilePath
import System.Directory

envdir = "./env"
main = do
	putStrLn "Hello!"
	files <- getDirectoryContents envdir
	let validFiles = [ fp | fp <- files, validEnvFile fp ] 
	printEnvDirContent validFiles
	printFileContent $ head validFiles


printEnvDirContent :: [FilePath] -> IO ()
printEnvDirContent files = do
	print files

validEnvFile :: FilePath -> Bool
validEnvFile = not . hasExtension

printFileContent :: FilePath -> IO ()
printFileContent fp = readFile (joinPath [envdir, fp]) >>= putStr