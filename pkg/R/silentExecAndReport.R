#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:

silentExecAndReport <- function(testfunc,sr){
  # this function executes testfunc()
  # and collects all its output to stdout 
  # if an error occures the error is reported along with its
  # messages and the callstack
  # if testfunc() returns a value this is stored 

  cout<-file(open="w+")
  sink(cout,type="output")
  oldWarn=getOption("warn")
  #options(warn=1) # print warnings immidiately , otherwise they will be printed
  # in the toplevel, so that we cant capture them specifically for the code
  # under test
  
	result <- NULL
	error<- NULL
	ret<- tryCatch(
		withCallingHandlers(
				error = function(e){
          # this is the error function of withCallingHandlers that
          # is called while stop() (=signalCondition) is active
          # it is a lisp like 'calling handler'
          # it does not prevent the error but executes code while it happens
          # we need this to see the actual call stack for the erroneous code
          # which we then store (per sideeffect) in a variable of the parent env (res<<-)
					res<<-sys.calls()
					#res<<-NULL
				},
				res <- testfunc()
		),
		error=function(e){
			# this is the error function of the tryCatch statement
      # it is an java/python  like 'exiting handler'
      # it is called after an error has been signaled and stop() returned
			# and returns another error
      # we need it to recover
			testError(e,callStack=res)
    },
		finally={
      
      #avoid unfinished last line for empty pseudofile hack
      write('\n',cout) 
      out <- readLines(cout) 

      sink(type="output")
     	close(cout)
      options(warn=oldWarn)
		
		}
	)
	if(inherits(ret,'testError')){
    sr$set_error(ret)
	}else{
		sr$add_retVal(ret)
	}	
  #sr$add_stdErr(msg)
  sr$add_stdOut(out)
  return(sr)
	#list(result=result,error=error,stdErr=msg,stdOut=out)
}
