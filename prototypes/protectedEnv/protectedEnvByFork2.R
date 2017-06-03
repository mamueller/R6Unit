#!/usr/bin/Rscript
# this variant is more explicit with respect from which process it reads
require(devtools)
require(R6)
A <- R6Class('A',public=list(error=0,failures=0))
devtools::install('tiny')
testfunc <- function(){
	require(tiny)
	arg <- 3
	res <- exported_package_func(arg)
	a <- A$new()
	return(a)
}



p <- parallel:::mcfork()
# in the parent p is of type childProcess
# in the child p is of type masterProcess
if (inherits(p, "masterProcess")) {
    cat("I'm a child! ", Sys.getpid(), "\n")
    parallel:::sendMaster(testfunc())
    parallel:::mcexit(,"I was a child")
}
cat("I'm the master\n")
a <- unserialize(parallel:::readChild(p))
print(a)

res <- tryCatch(
	# the next line will create an error
	# since the neccessary call to require happened
	# only in the forked process
	# this is what we want
	exported_package_func(3)
	,
	error=function(e){e}
)
print(inherits(res,'simpleError'))
