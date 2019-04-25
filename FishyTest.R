
# vim:set ff=unix expandtab ts=2 sw=2:
# this is an Example Class used by the tests to check the frameworks functionality
#----------------------------
FishyTest<-R6Class("FishyTest",
	inherit=TestCase,
	public=list(
		test.swimm=function(){
			print("swimming")
		}
    ,
		test.blubber=function(){
			cat("blubbering")
		} 
    , 
		test.error=function(){
       print('an error is about to occure.')
		   stop("an error did occure")
		} 
    ,
		test.fail=function(){
			self$assertTrue(1==2)
		}
	)
)
