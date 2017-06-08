#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
# This is a version of traceback_in_test_with_error.R that minimizes the time spent in sink
# build a constructor for a condition object (S3(
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    class = c(subclass, "condition"),
    list(message = message, call = call, ...)
  )
}
# build a constructor for the subclass testError that also contains a callstack
testError<- function(text,callStack) {
  msg <- paste0("testError: ", text)
  condition(c("testError", "error"),
    message = msg, 
    text = text,
    callStack=callStack
  )
}
summary.testError <- function(te){
  list(
    text=te$text,
    message=te$message,
    callStack=te$callStack
  )
}

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
			testError(text=e$message,callStack=res)
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


# example application
f <- function(){
  print('output from f')
  message('msg from f')
  warning('warning from f')
  3^2
}
f1 <- function(){
  print('output from f1')
  message('msg from f1')
  warning('warning from f1')
  f2()
}
f2 <- function(){
  print('output from f2')
  message('msg from f2')
  warning('warning from f2')
  stop('some error')
}
print(summary(silentExecAndReport(f1)$error))
#print(silentExecAndReport(f1)$error$callStack)
#print(silentExecAndReport(f))
