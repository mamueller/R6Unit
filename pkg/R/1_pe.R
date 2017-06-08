#
# vim:set ff=unix expandtab ts=2 sw=2:

pe=function(string,env=parent.frame()){
	### This function is used to print out a value of an quoted expression together with it and is helpful for debugging
  cat("\n########################################################################\n")
  callingFun <-as.list(sys.call(-1))[[1]]
  callerName<-toString(callingFun)
  res <- toString(eval(string,env))
  out <- sprintf('pe in %s:\nExpression\t: %s\nResult\t\t: %s \n',callerName,as.expression(string),res)
  cat(out)
  cat("\n########################################################################\n")
}
