# This is a version of traceback_in_test_with_error.R that avoids
f <- function(x){x^2}
f1 <- function(x){f2(x)}
f2 <- function(x){stop('some error')}

execOrReport <- function( func){
	tryCatch(
		withCallingHandlers(
				error = function(e){
					r<<-sys.calls()
				},
				r <- func(3)
		),
		error=function(e){list(e,r)}
	)
}
print(execOrReport(f1))
print(execOrReport(f))
