
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
      private$initIO()
      on.exit(private$restore())
      lines=as.character(body(funToTest))
      cfn="testCode.R"
      write(lines[2:length(lines)],cfn)
      res=system2(
        "Rscript"
        ,args=list(cfn)
        ,stdout="log.stdout"
        ,stderr="log.stderr"
      )
      if(res!=0){sr$set_fail()} 
      return(sr)
    }
  )
)
    
