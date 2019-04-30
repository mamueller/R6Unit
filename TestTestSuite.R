#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
#source("sourceR6Unit.R")
require(R6Unit)
require(getopt)
source("FishyTest.R")
TestTestSuite<-R6Class("TestTestSuite",
	inherit=TestCase,
	public=list(
    #-----------------------------------
		test.suite_initialization=function(){
			tb=FishyTest$new("test.blubber")
			ts=FishyTest$new("test.swimm")
      # first way, start with empty suite
      s1<-TestSuite$new()
      s1$add_test(tb)
      s1$add_test(ts)
      # second way, initilize from list
      s2<-TestSuite$new(list(tb,ts))
      ref<-c("FishyTest.test.blubber","FishyTest.test.swimm")
      self$assertEqual(
        s1$test_names(),
        ref 
      )
      self$assertEqual(
        s2$test_names(),
        ref
      )
    }
    ,
    #-----------------------------------
		test.suite_results=function(){
      s1<-get_suite(FishyTest)
      rl1<-s1$run()
      # run the suite again this time with a result argument
      rl2<-s1$run(rl1)
      self$assertEqual(2*rl1$get_nRuns(),rl2$get_nRuns())
    }
    ,
    #-----------------------------------
		test.add_suite=function(){
    # check that the tests stay unique
    # so if we add a suite to itself it stays the same 
    s1<-get_suite(FishyTest)
    refnames<-s1$test_names()
    s2<-get_suite(FishyTest)
    s1$add_suite(s2)
    self$assertEqual(refnames,s1$test_names())
    }
    ,
    #-----------------------------------
		test.suite_parallel=function(){
			tb=FishyTest$new("test.blubber")
			ts=FishyTest$new("test.swimm")
      # second way, initilize from list
      s<-TestSuite$new(list(tb,ts))
      s$parallel=2
      rl1<-s$run()
    }
  )
)
############################################ 
if(is.null(sys.calls()[[sys.nframe()-1]])){
  s=get_suite_from_file(get_Rscript_filename())
  s$parallel <- 1 
  tr<-s$run()
  cat(tr$summary())
}
