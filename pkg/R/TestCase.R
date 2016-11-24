
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
# the following function is actually a class method
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
        oldWarn=getOption("warn")
        options(warn=1) # print warnings immidiately , other wise they will be printed
        # in the toplevel, so that we cant capture them specifically for the code
        # under test
        cmsg<-textConnection("msg","w")
        cout<-textConnection("out","w")
        sink(cmsg,type="message")
        sink(cout,type="output")
				timing<-tryCatch(
            funToTest()
            ,error=function(err){return(err)}
            ,finally=c(
              sink(type="output")
              ,sink(type="message")
              ,close(cout)
              ,close(cmsg)
              ,options(warn=oldWarn)
            )
        )
        sr$add_output(out)
        if (inherits(timing, "simpleError")) { 
          sr$set_error() 
          msg<-paste(msg,toString(timing))
        }
        sr$add_message(toString(msg))
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
  )
)
    
