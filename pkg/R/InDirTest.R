
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
InDirTest<- R6Class("InDirTest",
  inherit=TestCase,
  private=list(
    res=NULL
    ,
    oldwd=NULL
    ,
    #----------------------------
    restore=function(){
      super$restore()
      setwd(private$oldwd)
    }
    ,
    #----------------------------
    initIO=function(){
      super$initIO()
      full_name<-self$full_name()
      myPrivateDirPath<-file.path("IoTestResults_tmp",full_name)
	    if(dir.exists(myPrivateDirPath)){
        lapply(
          list.files(include.dirs=TRUE,full.names=TRUE,myPrivateDirPath),
          function(p){unlink(p,recursive=TRUE)}
        )
      }else{
        dir.create(myPrivateDirPath,recursive=TRUE)
      }
      private$oldwd<-setwd(myPrivateDirPath)
    }
  )
  ,
  public = list(
    #----------------------------
    get_SingleTestResult= function() {
      
      sr<-SingleTestResult$new()
      private$res<-sr    
      l=as.list(self)
      if(is.element(self$name,names(l))){
        full_name<-self$full_name()
        sr$add_run(full_name)
        funToTest <- l[[self$name]]

        dirMsg<-paste("#################",getwd(),"#################\n")

        
        private$initIO()

				inDirSetUpTimeing<-tryCatch(
            self$inDirSetUp(),
            error=function(err){
              private$restore()
              return(err)
            }
        )
        sr$add_output(c(dirMsg,out))
        if (inherits(inDirSetUpTimeing, "simpleError")) { 
          sr$set_error() 
          msg<-paste(msg,"error in inDirTestSetUp", toString(inDirSetUpTimeing))
        }else{
          private$run_code(sr,funToTest)
        #  if (inherits(setupTiming, "simpleError")) { 
        #    sr$set_error() 
        #    msg<-paste(msg,"error in setUp", toString(setupTiming))
        #  }else{
        #    sr$add_message(msg)
				#    timing<-tryCatch(
        #        funToTest()
        #        ,error=function(err){return(err)}
        #        ,finally=private$restore()
        #    )
        #    sr$add_output(out)
        #    if (inherits(timing, "simpleError")) { 
        #      sr$set_error() 
        #      msg<-paste(msg,timing)
        #    }
        #    sr$add_message(msg)
        #  }
        }
      }else{
        cat(paste0("method: ", self$name," does not exist.\n"))
        return(NULL)
      }
      return(sr)
    }
    ,
    #----------------------------
    inDirSetUp=function(){
      # to be overloaded in subclasses
    }
  )
)
    
