#!/usr/bin/Rscript 
# The purpose of InDirScriptTest is to serve as a parent for 
# test classes that inherit from it. 
# Therefore we create such classes
require(R6Unit)
TestInDirScriptTest<-R6Class("TestInDirScriptTest",
	inherit=TestCase,
	public=list(
    #------------------------
	  test.writeInDir=function(){
      # create a small TestClass that tests some IO code
      IoScriptTest<-R6Class("IoScriptTest",
      	inherit=InDirScriptTest,
      	public=list(
      		test.write_and_read=function(){
            content="swimming"
            fn="myPersonalTestFile"
      			write(content,file=fn)
            print("hi there")
            res<-readLines(fn)[[1]]  
            stopifnot(identical(content,res))
      		}
      	)
      )
      iot<-IoScriptTest$new("test.write_and_read")
      sr<-iot$get_SingleTestResult()
      self$assertFalse(sr$has_failed())
	  }
    #,
    ##------------------------
	  #test.workingSetup=function(){
    #  # check if thw setUp function interpretes 
    #  # filepaths now locally
    #  IoScriptTest1<-R6Class("IoScriptTest1",
    #    inherit=InDirScriptTest,
    #    private=list(
    #      content="written by  setUp",
    #      #------------------------
    #      fn="myPersonalTestFile"
    #      #------------------------
    #    ),
    #    public=list(
    #      setUp=function(){
    #        print("######## everything is fine #############")
    #  			write(private$content,file=private$fn)
    #      }
    #      ,
    #      #------------------------
    #      test.somethingThatNeverFails=function(){
    #        self$assertTrue(TRUE)
    #        res<-readLines(private$fn)[[1]]  
    #        self$assertEqual(private$content,res)
    #      }
    #    )
    #  )
    #  iot<-IoScriptTest1$new("test.somethingThatNeverFails")
    #  sr<-iot$get_SingleTestResult()
    #  self$assertEqual(sr$has_error(),FALSE)
    #}
    #,
    ##------------------------
	  #test.failingSetup=function(){
    #  IoScriptTest2<-R6Class("IoScriptTest2",
    #    inherit=InDirScriptTest,
    #    public=list(
    #      setUp=function(){
    #        stop("an error in setup")
    #      }
    #      ,
    #      ####
    #      test.somethingThatNeverFails=function(){
    #        self$assertTrue(TRUE)
    #      }
    #    )
    #  )
    #  iot<-IoScriptTest2$new("test.somethingThatNeverFails")
    #  sr<-iot$get_SingleTestResult()
    #  self$assertEqual(sr$has_error(),TRUE)
    #}
  )
)

# check if the file is sourced or directly executed
if(is.null(sys.calls()[[sys.nframe()-1]])){
  s<-get_suite(TestInDirScriptTest)
  #s$parallel <- 1
  tr<-s$run()
  cat(tr$summary())
}
