#!/usr/bin/Rscript
# vim:set ff=unix expandtab ts=2 sw=2:
#source("sourceR6Unit.R",print.eval=FALSE)
require(R6Unit)
source("FishyTest.R")
#args <- commandArgs()
#print(args[[4]])

#----------------------------
TestTestCase<-R6Class("TestTestCase",
	inherit=TestCase,
	public=list(
		test.nRun=function(){
			res=TestResults$new()
			tc=FishyTest$new("test.blubber")
			tc$run(res)
			tc=FishyTest$new("test.fail")
			tc$run(res)
			tc=FishyTest$new("test.error")
			tc$run(res)
      self$assertTrue(res$get_nRuns()==3)
		}
    ,
		#--------------------------------------------
		test.nError=function(){
			res=TestResults$new()
			tc1=FishyTest$new("test.error")
			tc1$run(res)
      self$assertTrue(res$get_nErrors()==1)
      }
    ,
		#--------------------------------------------
		test.nFail=function(){
			res=TestResults$new()
			tc=FishyTest $new("test.fail")
			tc$run(res)
      self$assertTrue(res$get_nFailures()==1)
		}
    ,
		#--------------------------------------------
		test.Output=function(){
    # make sure that the output of the running code is
    # not lost but saved in the TestResults object
			#res=TestResults$new()
			tc<-FishyTest$new("test.blubber")
			sr<-tc$get_SingleTestResult()
      l<-sr$get_output()
      self$assertTrue(l=="blubbering")
    }
    ,
		#--------------------------------------------
		test.setUp=function(){
    # make sure that the output of the setUp FUnction is there
    setupMsg='in_setUp'
      FishyTestWithSetUpAndTearDown<-R6Class("FishyTestWithSetUpAndTearDown",
      	inherit=FishyTest
        ,
      	public=list(
      		setUp=function(){
      			cat(setupMsg)
      		}
      	)
      )
			tc<-FishyTestWithSetUpAndTearDown$new("test.blubber")
			sr<-tc$get_SingleTestResult()
      l<-sr$get_output()
      self$assertTrue(l==paste('in_setUp','blubbering',sep=''))
    }
	)
)
#----------------------------

# check if the file is sourced or directly executed
if(is.null(sys.calls()[[sys.nframe()-1]])){
  print("################ hello ####################")
  tr=TestResults$new()
  tc=TestTestCase$new("test.nError")
  tc$run(tr)
  tc=TestTestCase$new("test.nFail")
  tc$run(tr)
  tc=TestTestCase$new("test.nRun")
  tc$run(tr)
  tc=TestTestCase$new("test.Output")
  tc$run(tr)
  tr$summary()
}
#tc1=FishyTest$new("test.blubber")
#tc1$run(tr)
#tc2=FishyTest$new("test.swimm")
#tc2$run(tr)
