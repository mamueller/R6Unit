# The purpose is to get a traceback of an error that occured in a test
# This is achieved by sys.call() which has to be executed within withCallingHandler
# since the environment of the execution is not available for the error function
# if we use tryCatch 
# On the other hand withCallingHandlers does not recover from the error
# So we have to catch it wiht a surrounding tryCatch
f <- function(x){x^2}
f1 <- function(x){f2(x)}
f2 <- function(x){stop('some error')}

execute <- function(){
		withRestarts(
			f1(3),
			report_callStack=function(e){
				tr <- ""
				withCallingHandlers(
					f1(3),
					error=function(e){
						tr <<- sys.calls()
					}
				)
				return(tr)
			}
		)
}
res <- withCallingHandlers(
	execute(),
	error=function(){invokeRestart("report_callStack")},
)
print(res)
