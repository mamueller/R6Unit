
# vim:set ff=unix expandtab ts=2 sw=2:

TestSuite<- R6Class("TestSuite",
  private=list(
    tests=list()
  ),
  public=list(
    parallel=NULL
    ,
    #----------------------------
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
      if (is.null(self$parallel) || .Platform$OS.type!="unix"){
        resultList <- lapply(private$tests,function(test){test$get_SingleTestResult()}) 
      }else{
        require(parallel)
        # we implement a simpler version of 
        # mclapply here, since we have to make
        # sure that a subprocess is forked for >>every<< test
        # mclapply will not fork if mc.cores==1
        # but have to fork even then to protect our 
        # environment from side effects of the test code.
        n<-min(detectCores(),length(private$tests))
        cl<-makePSOCKcluster(n)
        clusterApply(private$tests,function(test({test$get_SingleTestResult()}))
        #jobs <- lapply(
        #  private$tests,
        #  function(test){
        #    mcparallel(test$get_SingleTestResult())
        #  }
        #)
        #resultList <- mccollect(jobs)
      }
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
