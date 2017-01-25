
# vim:set ff=unix expandtab ts=2 sw=2:
TestResults<-R6Class("TestResults",
  private=list(
    results=list()
  ),
  public = list(
    initialize=function(resultList=NULL){
      if(!is.null(resultList)){
        for(sr in resultList){
          self$add_SingleTestResult(sr)
        }
      }
    }
    ,
    add_SingleTestResult= function(res){
      if(all(class(res)==c("SingleTestResult","R6"))){
        private$results<- c(private$results,res)
      }
    }
    ,
    add_TestResults= function(res){
      if(all(class(res)==class(self))){
        private$results<- c(private$results,res$get_results())
      }
    }
    ,
    get_results=function(){
      return(private$results)
    }
    ,
    get_result_by_name=function(fullName){
      bool_inds<-unlist(lapply(private$results,function(sr){sr$get_fullName()==fullName}))
      return(private$results[bool_inds][[1]])
    }
    ,
    get_failures=function(){
      bool_inds<-unlist(lapply(private$results,function(sr){sr$has_failed()}))
      return(private$results[bool_inds])
    }
    ,
    get_errors=function(){
      bool_inds<-unlist(lapply(private$results,function(sr){sr$has_error()}))
      return(private$results[bool_inds])
    }
    ,
    get_nFailures=function(){
      frs<-self$get_failures()
      return(length(frs))
    }
    ,
    get_nErrors=function(){
      ers<-self$get_errors()
      return(length(ers))
    }
    ,
    get_nRuns=function(){
      l<-private$results
      return(length(l[unlist(lapply(l,function(el){!is.null(el)}))]))
    }
    ,
    summary=function(){
      tl<-myLogger()
      tl$info(
        paste0(
          ':\n',
          "test runs:\t",self$get_nRuns(),"\n",
          "failures:\t" ,self$get_nFailures(),"\n",
          "errors:\t\t" ,self$get_nErrors(),"\n.\n"
        )
      )
      #print(private$results)
      for (sr in private$results){
        sr$summary()
      }
    }
  )
)