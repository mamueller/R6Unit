#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
silentExecAndReport <- function(testfunc){
# this function executes testfunc()
# and collects all its output to stdout and stderr
# if an error occures the error is reported along with its
# messages and the callstack
# if testfunc() returns a value this is stored 
# this function returns a list
  cmsg<-file(open="w+")
  cout<-file(open="w+")
  sink(cmsg,type="message")
  sink(cout,type="output")
  oldWarn=getOption("warn")
  options(warn=1) # print warnings immidiately , otherwise they will be printed
  # in the toplevel, so that we cant capture them specifically for the code
  # under test
  
	result <- NULL
	error<- NULL
	ret<- tryCatch(
		withCallingHandlers(
				error = function(e){
          # this is the error function of withCallingHandlers that
          # is called while stop() (=signalCondition) is active
          # it is a 'calling handler'
          # it does not prevent the error but executes code while it happens
          # we need this to see the actual call stack for the erroneous code
          # which we then store (per sideeffect) in a variable of the parent env (res<<-)
					res<<-sys.calls()
				},
				res <- testfunc()
		),
		error=function(e){
			# this is the error function of the tryCatch statement
      # it is an 'exiting handler'
      # it is called after an error has been signaled and stop() returned
			# and returns another error
      # we need it to recover
			testError(e,callStack=res)
    },
		finally={
      out <- readLines(cout) 
      msg<- readLines(cmsg) 
      sink(type="output")
      sink(type="message")
     	close(cout)
      close(cmsg)
      options(warn=oldWarn)
		
		}
	)
	if(inherits(ret,'testError')){
		error <-ret
	}else{
		result <- ret
	}	
	list(result=result,error=error,stdErr=msg,stdOut=out)
}
