#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
require(R6Unit)
TestInDirTest<-R6Class("TestInDirTest",
	inherit=TestCase,
	public=list(
    #------------------------
	  test.get_SingleTestResult=function(){
      # create a small TestClass that tests some IO code
      IoTest<-R6Class("IoTest",
      	inherit=InDirTest,
      	public=list(
      		test.write_and_read=function(){
            content="swimming"
            fn="myPersonalTestFile"
      			write(content,file=fn)
            res<-readLines(fn)[[1]]  
            self$assertEqual(content,res)
      		}
      	)
      )
      iot<-IoTest$new("test.write_and_read")
      sr<-iot$get_SingleTestResult()
      self$assertEqual(sr$has_error(),FALSE)
	  }
    ,
    #------------------------
	  test.failingSetup=function(){
      IoTest<-R6Class("IoTest",
        inherit=InDirTest,
        public=list(
          inDirSetUp=function(){
            stop("an error in inDirSetUp")
          }
          ,
          ####
          test.somethingThatNeverFails=function(){
            self$assertTrue(TRUE)
          }
        )
      )
      iot<-IoTest$new("test.somethingThatNeverFails")
      sr<-iot$get_SingleTestResult()
      self$assertEqual(sr$has_error(),TRUE)
    }
  )
)

# check if the file is sourced or directly executed
if(is.null(sys.calls()[[sys.nframe()-1]])){
  s<-get_suite(TestInDirTest)
  tr<-s$run()
  tr$summary()
}
