#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
#source("sourceR6Unit.R")
require(R6Unit)
TestTestResults<-R6Class("TestTestResults",
	inherit=TestCase,
	public=list(
    #------------------------
		test.init=function(){
	    emptyResults<-TestResults$new()	
      rs<-ResultsFromList<-TestResults$new(
        list(
          SingleTestResult$new(),
          SingleTestResult$new()
        )
      )
      self$assertTrue(rs$get_nRuns()==2)
		}
	)
)
