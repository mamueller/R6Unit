
# vim:set ff=unix expandtab ts=2 sw=2:

TestSuite<- R6Class("TestSuite",
  private=list(
    tests=list()
  ),
  public=list(
    initialize=function(listOfTests=NULL){
      if(!is.null(listOfTests)){
        for(tc in listOfTests){
          self$add_test(tc)
        }
      }
    }
    ,
    #----------------------------
    get_tests=function(){
      return(private$tests)
    }
    ,
    #----------------------------
    add_test=function(tc){
      n<-tc$full_name()
      private$tests[[n]]<-tc
    }
    ,
    #----------------------------
    add_suite=function(s){
      for(tc in s$get_tests()){
        self$add_test(tc)
      }
    }
    ,
    #----------------------------
    run=function(pr=NULL){
      if(.Platform$OS.type!="unix"){
      n<-1}else{n<-2*detectCores()}
      resultList<-mclapply(
        private$tests,
        mc.cores=n,
        function(test){
          return(test$get_SingleTestResult())
        }
      )
      tr<-TestResults$new(resultList)
      if(!is.null(pr)){
        cpr=pr$clone(deep=TRUE)
        cpr$add_TestResults(tr)
        return(cpr)
      }else{
        return(tr)
      }
    }
    ,
    #----------------------------
    test_names=function(){
      return(names(private$tests))
    }

  )
  
)