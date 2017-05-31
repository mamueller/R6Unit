
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
InDirTest<- R6Class("InDirTest",
  inherit=TestCase,
  private=list(
    Io_tmp="IoTestResults_tmp"
    ,
    res=NULL
    ,
    oldwd=NULL
    ,
    oldLibPath=NULL
    ,
    #----------------------------
    myDirPath=function(){
      file.path(private$Io_tmp,self$full_name())
    }
    ,
    #----------------------------
    restore=function(){
      super$restore()

      .libPaths(private$oldLibPath)
      unlink(private$oldLibPath,recursive=TRUE,force=TRUE)
      setwd(private$oldwd)
    }
    ,
    #----------------------------
    initIO=function(){
      super$initIO()
	    if(dir.exists(private$myDirPath())){
        lapply(
          list.files(include.dirs=TRUE,full.names=TRUE,private$myDirPath()),
          function(p){unlink(p,recursive=TRUE)}
        )
      }else{
        dir.create(private$myDirPath(),recursive=TRUE)
      }
      myLib <- 'lib'
      dir.create(myLib,recursive=TRUE)
      for (d  in .libPaths()){
        for (pd  in d){
          cpDir(pd,myLib)
        }
      }
      private$oldLibPath <- .libPaths(myLib)
      private$oldwd<-setwd(private$myDirPath())
    }
  )
)
    
