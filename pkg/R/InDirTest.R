
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
InDirTest<- R6Class("InDirTest",
  inherit=TestCase,
  private=list(
    res=NULL 
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
        oldWarn=getOption("warn")
        options(warn=1) # print warnings immidiately , other wise they will be printed
        # in the toplevel, so that we cant capture them specifically for the code
        # under test
        myPrivateDirPath<-file.path("IoTestResults_tmp",full_name)
	      if(dir.exists(myPrivateDirPath)){
          lapply(
            list.files(include.dirs=TRUE,full.names=TRUE,myPrivateDirPath),
            function(p){unlink(p,recursive=TRUE)}
          )
        }else{
          dir.create(myPrivateDirPath,recursive=TRUE)
        }
        oldwd<-setwd(myPrivateDirPath)
        dirMsg<-paste("#################",getwd(),"#################\n")

        
        cmsg<-textConnection("msg","w")
        cout<-textConnection("out","w")
        sink(cmsg,type="message")
        sink(cout,type="output")

        restore<-function(){
          sink(type="output")
          sink(type="message")
          close(cout)
          close(cmsg)
          options(warn=oldWarn)
          setwd(oldwd)
        }
				setupTiming<-tryCatch(
            self$inDirSetUp(),
            error=function(err){
              restore()
              return(err)
            }
        )
        sr$add_output(c(dirMsg,out))
        if (inherits(setupTiming, "simpleError")) { 
          sr$set_error() 
          msg<-paste(msg,"error in inDirTestSetUp", toString(setupTiming))
        }else{
          sr$add_message(msg)

				  timing<-tryCatch(
            funToTest() ,
            error=function(err){return(err)} ,
            finally=restore()
          )
          sr$add_output(c(dirMsg,out))
          if (inherits(timing, "simpleError")) { 
            sr$set_error() 
            msg<-paste(msg,timing)
          }
          sr$add_message(msg)
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
    
