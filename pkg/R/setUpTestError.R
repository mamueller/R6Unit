
# vim:set ff=unix expandtab ts=2 sw=2:
# build a constructor for the subclass setUpTestError 
setUpTestError<- function(testError) {
  testMsg <- testError$message
  testText<- testError$text
  callStack <- testError$callStack
  msg <- paste0("setUpTestError: ", testMsg)
  condition(c("setUpTestError", class(testError),"error"),
    message = msg, 
    text = text,
    callStack=callStack
  )
}

