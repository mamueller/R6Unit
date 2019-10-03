
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
    get_error= function(){
      private$error
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
      private$stdOut<-c(private$stdOut,messages)
    }
    ,
    add_stdErr=function(messages){
      private$stdErr<-c(private$stdErr,messages)
    }
    ,
    get_stdErr=function(){
      private$stdErr
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
    summary= function(){
        td<-private
        textLines<-unlist(lapply(
            c('fullName','failure','error','stdOut','stdErr')
            ,function(n){
              entry=td[[n]]
              text<-sprintf("%s:\n",n)
              text<-c(entry)
                if (n=='error'){
                  callStack <- entry$callStack
                  text<- c(text,callStack[20:length(callStack)])
                }
              text
            }
        ))
    }
  )
)
