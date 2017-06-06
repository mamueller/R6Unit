# The purpose is to get a traceback of an error that occured in a test
# This is achieved by sys.call() which has to be executed within withCallingHandler
# since the environment of the execution is not available for the error function
# if we use tryCatch 
# On the other hand withCallingHandlers does not recover from the error
# So we have to catch it wiht a surrounding tryCatch
f <- function(x){x^2}
f1 <- function(x){f2(x)}
f2 <- function(x){stop('some error')}

cout<-file(open="w+")
sink(cout,type="output")
timing <- tryCatch(
  	withCallingHandlers(
		f1(3),
		# define the error function called in inside stop
		error=function(e,msg=""){ 
			tr <- sys.calls()
			print(tr)
		}
	)
	,
	# define the error function called in tryCatch (after f1(3) returned)
	error = function(e){e},
	finally = {
			msg <- readLines(cout)
			sink(type="output")
			close(cout)
		}
)	
if (inherits(timing,'simpleError')){
	msg <- append('An error occured, the callstack:',msg)
}
print(msg)
print('done')
