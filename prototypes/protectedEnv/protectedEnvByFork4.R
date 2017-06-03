#!/usr/bin/Rscript
# this variant is parallel
require(devtools)
require(R6)
A <- R6Class('A',public=list(value=0))
devtools::install('tiny')
testfunc <- function(i){
	require(tiny)
	arg <- 3
	res <- exported_package_func(arg)
	a <- A$new()
	a$value <- i
	
	return(a)
}



results <- parallel:::mclapply(
	#1:1, since mclapply does not fork for one element lists we would get into trouble
        1:2 		
	function(x){testfunc(x)}
)
print(results)

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
print(res)
