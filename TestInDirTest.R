#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:
require(R6Unit)
TestInDirTest<-R6Class("TestInDirTest",
	inherit=TestCase,
	public=list(
    #------------------------
	  test.writeInDir=function(){
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
		test.cpDir=function(){
      #create a nested testdir
      pkgDir <- "test"
      RDir<-"R"
      manDir<-"man"
      manManDir<-file.path("man","manMan")
      dir.create(file.path(pkgDir,RDir),recursive=TRUE)
      dir.create(file.path(pkgDir,manDir),recursive=TRUE)
      dir.create(file.path(pkgDir,manManDir),manManDir,recursive=TRUE)
      testFileName <- "source.R"
      file.create(file.path(pkgDir,RDir,testFileName))

      # copy the whole tree
      back<-paste0(pkgDir,"_bak")
      cpDir(pkgDir,back)
      #
      ##check if everything is there
      self$assertTrue(dir.exists(file.path(back,RDir)))
      self$assertTrue(dir.exists(file.path(back,manDir)))
      self$assertTrue(dir.exists(file.path(back,manManDir)))
      self$assertTrue(file.exists(file.path(back,RDir,testFileName)))
		}
    ,
    #--------------------------------
	  test.workingSetup=function(){
      # check if thw setUp function interpretes 
      # filepaths now locally
      IoTest1<-R6Class("IoTest1",
        inherit=InDirTest,
        private=list(
          content="written by  setUp",
          #------------------------
          fn="myPersonalTestFile"
          #------------------------
        ),
        public=list(
          setUp=function(){
            print("######## everything is fine #############")
      			write(private$content,file=private$fn)
          }
          ,
          #------------------------
          test.somethingThatNeverFails=function(){
            self$assertTrue(TRUE)
            res<-readLines(private$fn)[[1]]  
            self$assertEqual(private$content,res)
          }
        )
      )
      iot<-IoTest1$new("test.somethingThatNeverFails")
      sr<-iot$get_SingleTestResult()
      self$assertEqual(sr$has_error(),FALSE)
    }
    ,
    #------------------------
	  test.failingSetup=function(){
      IoTest2<-R6Class("IoTest2",
        inherit=InDirTest,
        public=list(
          setUp=function(){
            stop("an error in setup")
          }
          ,
          ####
          test.somethingThatNeverFails=function(){
            self$assertTrue(TRUE)
          }
        )
      )
      iot<-IoTest2$new("test.somethingThatNeverFails")
      sr<-iot$get_SingleTestResult()
      self$assertEqual(sr$has_error(),TRUE)
    }
  )
)

# check if the file is sourced or directly executed
if(is.null(sys.calls()[[sys.nframe()-1]])){
  s<-get_suite(TestInDirTest)
  #s$parallel <- 1
  tr<-s$run()
  cat(tr$summary())
}
