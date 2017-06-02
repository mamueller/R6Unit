
# vim:set ff=unix expandtab ts=2 sw=2:
# firs attempt at logging wiht anonymous files
# by returning the conections
# have a look at a different approch where the connections are ObjectProperties
# in sink_private.R

require(R6)
doSomethingWrong <- function(){
  # firs Chatter
  print(4545454545) 
  print(4545454545) 
  print(4545454545) 
  res <- 3
  stop('here comes the error message')
  # now make the mistake
  return(res)
}
IO <- R6Class( 
  'IO'
  ,
  public=list(
    sinker=function(){
    	cs<-file(open="w+")
    	co<-file(open="w+")
    	sink(cs,type='message')
    	sink(co,type='output')
      return(list(cs,co))
    }
    ,
    gatherer=function(){
      l <- self$sinker()
      cmsg <- l[[1]]
      cout <- l[[2]]
      timing <- tryCatch( 
        doSomethingWrong()
        ,error=function(err){return(err)}
        ,finally=r <- self$unSinker(cout,cmsg)
      )
      r[[2]]  <- append(r[[2]],timing)
      return(r)
      
    }
    ,
    unSinker=function(co,cs){
      m <- readLines(cs)
      o <- readLines(co)
    	sink(type='output')
    	sink(type='message')
      close(co)
      close(cs)
      return(list(o,m))
    }
  )
)
io=IO$new()
print(io$gatherer())

