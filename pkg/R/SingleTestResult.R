
# vim:set ff=unix expandtab ts=2 sw=2:
SingleTestResult<-R6Class("SingleTestResult",
  private=list(
    fullName="",
    deactivated=FALSE,
    failure=FALSE,
    error=NULL,
    stdErr='',
    stdOut='',
    retVal=NULL# this is a convinience for testing tests
  )
  ,
  public = list(
    add_run= function(fullName){
      private$fullName<- fullName
    }
    ,
    get_fullName= function(){
      private$fullName
    }
    ,
    add_stdErr=function(messages){
      private$stdErr<-append(private$stdErr,messages)
    }
    ,
    add_retVal=function(messages){
      private$retVal<-messages
    }
    ,
    get_retVal=function(messages){
      private$retVal
    }
    ,

    add_stdOut=function(messages){
      private$stdOut<-append(private$stdOut,messages)
    }
    ,
    get_stdOut=function(){
      private$stdOut
    }
    ,
    set_deactivated= function(fullName){
      private$deactivated<-TRUE
      private$fullName<- fullName
    }
    ,
    set_fail = function(){
      private$failure<-TRUE
    }
    ,
    has_been_deactivated= function(){
      private$deactivated
    }
    ,
    has_failed = function(){
      private$failure
    }
    ,
    set_error= function(err){
      private$error<- err
    }
    ,
    has_error = function(){
      !is.null(private$error)
    }
    ,
    summary= function(sharedLogger=NULL){
        td<-private
        textLines<-character()
        #prepare the output
        for(n in setdiff(names(td),'retVal')){
          entry <- paste(td[[n]],collapse="\n")
          if (n=='error'){
            err <- td[[n]]
            callStack <- err$callStack
            callStack <- callStack[20:length(callStack)]
            #callStack <- callStack[9:length(callStack)]
            entry <- c(entry,callStack)
          }
          textLines<-c(textLines,sprintf("\n%s:=%s",n,entry))
        }
        if (!is.null(sharedLogger)){
          # write on common Log
          if(self$has_failed() | self$has_error()){
            # make sure to be verbose in case of error or failure
            sharedLogger$error(textLines)
          }else{
            # otherwise only talk if loglevel is above debug
            sharedLogger$debug(textLines)
          }
        }
        # create a private logger that writes only to a private
        # logfile and is always verbose
        logDirName <- 'logs'
	      if(!dir.exists(logDirName)){
          dir.create(logDirName)
        }
        logFileName<-file.path('logs',private$fullName)
        privateLogger<-myLogger(logFileName)
        fileLogLevel<-c(FINEST=1)
        unlink(logFileName)
        privateLogger<-getLogger("privateTestLogger")
        privateLogger$level<-fileLogLevel
        privateLogger$addHandler(writeToFile,level=fileLogLevel,file=logFileName)
        # make sure to be verbose by 
        privateLogger$error(textLines)
      }
  )
)
 
 
 
 
 
 
 
 
 
 
 
 
