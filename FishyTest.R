#
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
		   stop("an erroneous method")
		} 
    ,
		test.fail=function(){
			self$assertTrue(1==2)
		}
	)
)
