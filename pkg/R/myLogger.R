#!/usr/bin/Rscript
# vim:set ff=unix expandtab ts=2 sw=2:
myLogger<-function(logFileName){
  fileLogLevel<-c(FINEST=1)
  consoleLogLevel<-c(INFO=20)
  #logFileName<-"test.log"
  unlink(logFileName)
  tl<-getLogger("TestLogger")
  tl$level<-fileLogLevel
  tl$addHandler(writeToConsole, level=consoleLogLevel)
  tl$addHandler(writeToFile,level=fileLogLevel,file=logFileName)
  return(tl)
}

