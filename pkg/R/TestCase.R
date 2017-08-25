
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
    msg=NULL
    ,
    out=NULL
    ,
    oldWarn=NULL
    ,
    #----------------------------
    initIO=function() {
       # to be overloaded by children
    }
    ,
    #----------------------------
    restore=function(){
       # to be overloaded by children
    }
    ,
    #----------------------------
    run_code=function(sr,funToTest){
      private$initIO()
      on.exit(private$restore())
      
      sr<- silentExecAndReport(self$setUp,sr)
      msg=''
      if (sr$has_error()){
        return(sr)
      }
      else{
        sr <- silentExecAndReport(funToTest,sr)
      }
      return(sr)
    }
  )
  ,
  public = list(
    name = NULL
    ,
    # The resource Dir Path will be interpreted relative to the directory
    # where the Test is run.
    # If you have a nested directories with tests it could be in the top level
    # directory.
    # In that case you would either have to run the testsuites always from there
    # or if you want to execute them separately you could provide symlinks
    # in the subdirectories.
    # You can easily overload the actual path when inheriting from this class
    resourceDirPath='R6UnitTestResources'
    ,
    Io_tmp="IoTestResults_tmp"
    ,
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
        funToTest <- l[[self$name]]
        fs<-formals(funToTest)
        if(!is.null(fs)){
          if(is.element('SKIP',names(fs))){
            sr$set_deactivated(self$full_name())
          }
        }
        else{
          sr$add_run(self$full_name())
          private$run_code(sr,funToTest)
        }
      }else{
        cat(paste0("method: ", self$name," does not exist.\n"))
        return(NULL)
      }
      return(sr)
    }
    ,
    #----------------------------
    DEACTIVATE= function (expr, msg = ""){
      sr$set_deactivated()
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
    
