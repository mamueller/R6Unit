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
		test.resourceDir=function(){
      # create a test_resources directory
      testResourceDir <- self$resourceDirPath
      if(!dir.exists(testResourceDir)){
        dir.create(testResourceDir,recursive=TRUE)
      }
      content="swimming"
      fn="myPersonalTestFile"
      fp=file.path(testResourceDir,fn)
      write(content,file=fp)
      ReadingTest<-R6Class("ReadingTest",
      	inherit=TestCase,
      	public=list(
		      #--------------------------------------------
          test.readFromResources=function(){
            rd <- self$resourceDirPath
            fn <- "myPersonalTestFile"
            fp <- file.path(rd,fn)
            cat(toString(readLines(fp)[[1]]))  
            
          }
        )
      )
      tc <-ReadingTest$new('test.readFromResources')
			sr<-tc$get_SingleTestResult()
      l<-sr$get_output()
      print(class(l))
      print(l)
      self$assertTrue(l==content)
      #m<-sr$get_messages()
      #sr$summary()
      #print(m)

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
  s=get_suite_from_file(get_Rscript_filename())
  s$parallel <- 1 
  #print(s$get_tests())
  tr<-s$run()
  tr$summary()
  }
#  tr=TestResults$new()
#  tc=TestTestCase$new("test.nError")
#  tc$run(tr)
#  tc=TestTestCase$new("test.nFail")
#  tc$run(tr)
#  tc=TestTestCase$new("test.nRun")
#  tc$run(tr)
#  tc=TestTestCase$new("test.Output")
#  tc$run(tr)
#  tr$summary()
#}
#tc1=FishyTest$new("test.blubber")
#tc1$run(tr)
#tc2=FishyTest$new("test.swimm")
#tc2$run(tr)
