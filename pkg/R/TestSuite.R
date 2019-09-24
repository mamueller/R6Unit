
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
        n<-min(detectCores(),length(private$tests))

        # the next lines are supposed to make helper functions used to define tests 
        # available to the cluster nodes
        # by default clusterApply does not make everything available which leads to problems
        # when a test uses an external function since the function is not available in
        # the environment of the node.
        # options:
        # 1.) clusterExport(cl=cl,varlist=ls(e),env=e) 
        #     where e should be an environment containing all objects (usually
        #     functions) used to define the test.  

        cl<-makePSOCKcluster(n)
        resultList <- clusterApply(cl,private$tests,function(test){test$get_SingleTestResult()})
        # we implement a simpler version of 
        # mclapply here, since we have to make
        # sure that a subprocess is forked for >>every<< test
        # mclapply will not fork if mc.cores==1
        # but have to fork even then to protect our 
        # environment from side effects of the test code.
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
