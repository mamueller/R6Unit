require(devtools)
devtools::install('tiny')
testfunc <- function(){
	require(tiny)
	arg <- 3
	res <- exported_package_func(arg)
	return(res==arg)
}
executor <- function(f){
	run <- function(fun){
		tryCatch(
			 fun(),
			 error=function(err){err}
		)
	}
	e <- new.env()
	return(eval(run(f),e))
}
# unfortunaetly the following line has a sideffect
# evaluating the testfunc in the new environment does not prevent the library
# from the searchpath after the execution
# if you comment it out exported_package_func will not be available
print(executor(testfunc))	

print(exported_package_func(3))
	
	
