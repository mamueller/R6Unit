
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
InDirTest<- R6Class("InDirTest",
  inherit=TestCase,
  public=list(
    libSnap=NULL
  )
  ,
  #----------------------------
  private=list(
    res=NULL
    ,
    oldwd=NULL
    ,
    oldLibPath=NULL
    ,
    newLibPath=NULL
    ,
    #----------------------------
    myDirPath=function(){
      file.path(self$Io_tmp,self$full_name())
    }
    ,
    #----------------------------
    restore=function(){
      super$restore()

      .libPaths(private$oldLibPath)
      unlink(private$newLibPath,recursive=TRUE,force=TRUE)
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
      # change into the private Dir
      private$oldwd<-setwd(private$myDirPath())
      myLib <- 'lib'
      dir.create(myLib,recursive=TRUE)
      private$oldLibPath <- .libPaths()
      # copy the libraries except the system lib 
      # into one new libary dir.
      # Since .libPaths(nes) does not change the system library 
      # as the last entry we do not have to copy its contents.
      # It will remain as the last entry in the changed .libPaths vector anyway.
      #
      # We copy the contents of the libDirs  in reversed order 
      # since the same package might be installed in different places
      # and library will take the first location if not explicitly instructed otherwise
      # If we copy both instances into our private lib the one first on the search path will be copied
      # last (and overwrite) the one further back in the search path.

      #for (lp in rev(head(op,length(op)-1))){
      #  for (pd in list.dirs(lp)){
      #    file.copy(pd,myLib,recursive=TRUE)
      #  }
      #}
      .libPaths(myLib)
      private$newLibPath <- .libPaths()
    }
  )
)
    
