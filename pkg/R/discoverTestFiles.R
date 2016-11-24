
# vim:set ff=unix expandtab ts=2 sw=2:
get_suitefromDiscoveredTestInstances<-function(tldir,pattern){
  tllist<-list.files(path=tldir,pattern)
  s<-TestSuite$new()
  for (tc in tllist){
    s$add_suite(get_suite_from_file(tc))
  }
  return(s)
 }

#---------------------------------------
get_suite_from_file<-function(fn){
  tcs=discoverTestClassesInFile(fn)
  s<-TestSuite$new()
  for (tc in tcs){
    s$add_suite(get_suite(tc))
  }
  return(s)
}
  
#---------------------------------------
discoverTestClassesInFile<-function(fn){
  env=new.env()
  exprs<-parse(fn)
  for (expr in exprs) { 
    eval(expr,env)
  }
  le<-as.list(env)
  TestClasses<-le[as.logical(lapply(le,function(el){is.Test(el)}))]
  return(TestClasses)
}
#---------------------------------------
#discoverTestClasses<-function(tldir,pattern){
#  tllist<-list.files(path=tldir,pattern)
#  env=new.env()
#  lapply(
#      tllist,
#      function(fn){
#        exprs<-parse(fn)
#        for (expr in exprs) { 
#          eval(expr,env)
#        }
#      }
#  )
#  le<-as.list(env)
#  TestClasses<-le[as.logical(lapply(le,function(el){is.Test(el)}))]
#  return(TestClasses)
#}
#---------------------------------------
ancestorNames<-function(cls){
  #recursive function to find ancestors
  if(is.R6Class(cls)){
    pcn<-cls$inherit
	  if(is.null(pcn)){
	  	return(c())
    }else{
      return(c( pcn,ancestorNames(cls$get_inherit())))
    } 
  }else{
    return(NULL)
  }
}
#---------------------------------------
is.Test<-function(cls){
  b<-is.R6Class(cls) && is.element("TestCase",ancestorNames(cls))
  return(b)
}



