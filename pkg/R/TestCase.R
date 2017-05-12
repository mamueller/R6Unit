
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
# the following functions are actually class methods
get_suite=function(cls){
  l<-names(cls$public_methods) 
  bool_inds<-grepl(pattern="^test.*",l)
  testFunctionNames<-l[bool_inds]
  tests<-lapply(testFunctionNames,function(n){cls$new(n)})
  s<-TestSuite$new(tests)
  return(s)
}

TestCase<- R6Class("TestCase",
  private=list(
    res=NULL
    ,
    cmsg=NULL
    ,
    cout=NULL
    ,
    oldWarn=NULL
    ,
    #----------------------------
    initIO=function() {
        private$cmsg<-textConnection("msg","w")
        private$cout<-textConnection("out","w")
        sink(private$cmsg,type="message")
        sink(private$cout,type="output")

        private$oldWarn=getOption("warn")
        options(warn=1) # print warnings immidiately , otherwise they will be printed
        # in the toplevel, so that we cant capture them specifically for the code
        # under test
    }
    ,
    #----------------------------
    restore=function(){
      sink(type="output")
      sink(type="message")
      close(private$cout)
      close(private$cmsg)
      options(warn=private$oldWarn)
    }
    ,
    #----------------------------
    run_code=function(sr,funToTest){
		  setupTiming<-tryCatch(
          self$setUp(),
          error=function(err){
            private$restore()
            return(err)
          }
      )
      if (inherits(setupTiming, "simpleError")) { 
        sr$set_error() 
        msg<-paste(msg,"error in setUp", toString(setupTiming))
      }else{
        sr$add_message(msg)
		    timing<-tryCatch(
            funToTest()
            ,error=function(err){return(err)}
            ,finally=private$restore()
        )
        sr$add_output(out)
        if (inherits(timing, "simpleError")) { 
          sr$set_error() 
          msg<-paste(msg,timing)
        }
        sr$add_message(msg)
      }
    }
  )
  ,
  public = list(
    name = NULL,
    initialize = function(testMethodName) {
        self$name <- testMethodName
    }
    ,
    #----------------------------
    full_name= function(){
      ClassName=attr(self,"class")[[1]]
      return(toString(paste(ClassName,self$name,sep=".")))
    }
    ,
    #----------------------------
    run = function(tr) {
      sr<-self$get_SingleTestResult()
      tr$add_SingleTestResult(sr)
    }
    ,
    #----------------------------
    get_SingleTestResult= function() {
      #reference the result object we are dealing with (needed later to collect errors failures 
      sr<-SingleTestResult$new()
      private$res<-sr    
      l=as.list(self)
      if(is.element(self$name,names(l))){
        sr$add_run(self$full_name())
        funToTest <- l[[self$name]]
        private$initIO()

        private$run_code(sr,funToTest)
      }else{
        cat(paste0("method: ", self$name," does not exist.\n"))
        return(NULL)
      }
      return(sr)
    }
    ,
    #----------------------------
    assertTrue= function (expr, msg = ""){
      sr<-private$res
      if (missing(expr)) {
          stop("'expr' is missing")
      }
      result <- eval(expr)
      names(result) <- NULL
      if (!identical(result, TRUE)) {
        sr$set_fail()
      }
    }
    ,
    #----------------------------
    assertEqual= function (arg1, arg2 ,msg= ""){
      sr<-private$res
      if (identical(arg1,arg2)){
        return()
      }else{
        if(is.numeric(arg1)&&is.numeric(arg2)){
          if(arg1-arg2==0){
            return()
          }
        } 
        message(
          sprintf("test Failure in assertEqual:\n arg1:= '%s' \n arg2:= '%s'\n",
            toString(arg1),toString(arg2)))
        sr$set_fail()
      }
    }
    ,
    #----------------------------
    setUp=function(){
      # to be overloaded in subclasses
    }
  )
)
    
