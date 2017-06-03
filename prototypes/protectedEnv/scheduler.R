#!/usr/bin/Rscript
lapplyInChunks<- function(vec,npar,func){
	l <- length(vec)
	takeN <- function(cn){
		min_ind <- 1+cn*npar 
		max_ind <- min(l,min_ind+npar)
		myArgs <- vec[min_ind:max_ind]
		print(myArgs)
		myResults<-lapply(myArgs,func)
	} 
	cns <- 0:floor(l/npar)
	print(cns)
	results<- unlist(lapply(cns,takeN))
}
results <- lapplyInChunks(vec=1:20,npar=3,func=function(x){x^2})
print(results)
	
	
