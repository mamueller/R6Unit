
# vim:set ff=unix expandtab ts=2 sw=2:
#----------------------------
# this Testclass will extract the body of the testfunction and run it in a new
# process with Rscript in a testfunction specific directory
# to guarante maximum isolation and reproducebility.
# The script code can be run independently of the test framework for debugging
# The downside is that the testframework can not be used inside the function body
# so we do not have the extra comfortable asserts of the framework but have to use 
# something like stopifnot to break the test if an assertion fails.
InDirScriptTest<- R6Class("InDirScriptTest",
  inherit=InDirTest,
  ##----------------------------
  private=list(
    #----------------------------
    run_code=function(sr,funToTest){
      sr$add_stdOut(c("##################################",private$myDirPath())) 
	    if(dir.exists(private$myDirPath())){
        lapply(
          list.files(include.dirs=TRUE,full.names=TRUE,private$myDirPath()),
          function(p){unlink(p,recursive=TRUE)}
        )
      }else{
        dir.create(private$myDirPath(),recursive=TRUE)
      }
      # change into the private Dir
      private$oldwd<-setwd(private$myDirPath())
      
      # create a testspecific library
      myLib <- 'lib'
      dir.create(myLib,recursive=TRUE)

      oldLibPaths <- .libPaths()
      newLibPaths <- append(myLib,oldLibPaths)
      on.exit(setwd(private$oldwd))
      prolog=as.character(body(self$setUp))
      lines=as.character(body(funToTest))
      cfn="testCode.R"
      if (length(prolog)>1){ write(prolog[2:length(prolog)],cfn)}
      if (length(lines)>1){write(lines[2:length(lines)],cfn,append=TRUE)}
      res=system2(
        "Rscript"
        ,args=list(cfn)
        ,stdout="log.stdout"
        ,stderr="log.stderr"
      )
      if(res!=0){
        sr$set_fail()
        sr$add_stdOut(readLines("log.stdout"))
        sr$add_stdErr(readLines("log.stderr"))
      } 
      return(sr)
    }
  )
)
    
