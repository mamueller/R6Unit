require(R6)
IO <- R6Class(
	"IO"
	,
	private=list(
		mc=NULL
		,
		oc=NULL
		,
		msg=NULL
		,
		out=NULL
		,
		sinker=function(){
			private$mc=file(open='w+')
			private$oc=file(open='w+')
			sink(private$mc,type='message')
			sink(private$oc,type='output')
		}
		,
		restore=function(){
			private$msg <- readLines(private$mc)
			private$out <- readLines(private$oc)
			sink(type='message')
			sink(type='output')
			close(private$mc)
			close(private$oc)
		}
	)
	,
	public=list(
		reporter=function(){
			private$sinker()
			timing <- tryCatch(
				{
					print("some output")
					message("some message")
					stop("some error")
				}
				,
				finally=private$restore()
				,
				error=function(e){return(e)}
			)
			
			msg <- private$msg
			out <- private$out
			msg <- append(msg,timing)
			#out <- append(out,timing)
			return(list(message=msg,output=out))
		}
	)
)
io=IO$new()
print(io$reporter())
