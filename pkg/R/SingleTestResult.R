
# vim:set ff=unix expandtab ts=2 sw=2:
SingleTestResult<-R6Class("SingleTestResult",
  private=list(
    fullName="",
    failure=FALSE,
    error=FALSE,
    output="",
    messages=""
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
    add_message=function(messages){
      private$messages<-messages
    }
    ,
    add_output=function(output){
      private$output<-output
    }
    ,
    get_output=function(output){
      private$output
    }
    ,
    set_fail = function(){
      private$failure<-TRUE
    }
    ,
    has_failed = function(){
      private$failure
    }
    ,
    set_error= function(){
      private$error<- TRUE
    }
    ,
    has_error = function(){
      private$error
    }
    ,
    summary= function(){
      tl<-myLogger()
      td<-private
      textLines<-character()
      for(n in names(td)){
        #textLines<-c(textLines,sprintf("\n%s:=%s",n,toString(td[[n]])))
        textLines<-c(textLines,sprintf("\n%s:=%s",n,paste(td[[n]],collapse="\n")))
      }
      #textLines=toString(paste(textLines,sep="\n"))
      if(self$has_failed() | self$has_error()){
        # make sure to be verbose in case of error or failure
        tl$error(textLines)
      }else{
        # otherwise only talk if loglevel is above debug
        tl$debug(textLines)
      }
    }
  )
)
