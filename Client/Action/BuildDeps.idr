module Client.Action.BuildDeps

import Data.List
import Data.Strings
import Fmt
import Inigo.Async.Base
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Util.Path.Path

depsDir : String
depsDir = "./Deps"

buildIPkg : String -> Promise ()
buildIPkg ipkg =
  do
    log (fmt "Compiling %s" ipkg)
    system "idris2" ["--build", ipkg] False True
    log (fmt "Compiled %s" ipkg)

export
buildDeps : Promise ()
buildDeps =  
  do
    files <- fs_getFilesR depsDir
    let ipkgs = filter (isSuffixOf ".ipkg") files
    all $ map buildIPkg ipkgs 
    pure ()
