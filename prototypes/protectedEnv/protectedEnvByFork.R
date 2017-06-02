require(devtools)
devtools::install('tiny')
testfunc <- function(){
	require(tiny)
	arg <- 3
	res <- exported_package_func(arg)
	return(res==arg)
}


#exported_package_func 

p <- parallel:::mcfork()
if (inherits(p, "masterProcess")) {
    cat("I'm a child! ", Sys.getpid(), "\n")
    parallel:::sendMaster(testfunc())
    parallel:::mcexit(,"I was a child")
}
cat("I'm the master\n")
unserialize(parallel:::readChildren(1.5))

print(exported_package_func(3))
