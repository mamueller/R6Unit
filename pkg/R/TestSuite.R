
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
      n<-min(detectCores(),length(private$tests))
      if(.Platform$OS.type!="unix"){
        n <- 1
      } 
      if(!is.null(self$parallel)){
        n <- self$parallel
      }
      print(n)
      #resultList<-mclapply(
      #  private$tests,
      #  mc.cores=n,
      #  function(test){
      #    return(test$get_SingleTestResult())
      #  }
      #)
      # we implement a simpler version of 
      # mclapply here, since we have to make
      # sure that a subprocess is forked for >>every<< test
      # mclapply will not fork if mc.cores==1
      # but have to fork even then to protect our 
      # environment from side effects of the test code.

      jobs <- lapply(
        private$tests,
        function(test){
          mcparallel(test$get_SingleTestResult())
        }
      )
      resultList <- mccollect(jobs)
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
