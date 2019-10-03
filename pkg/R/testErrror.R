
# vim:set ff=unix expandtab ts=2 sw=2:
# build a constructor for the subclass testError that takes an existing error and
# the callstac that lead to it.
testError<- function(orgError,callStack) {
  orgMsg <- orgError$message
  orgText<- orgError$text
  msg <- c("testError: ", orgMsg)
  condition(c("testError", class(orgError),"error"),
    message = msg, 
    text = orgText,
    callStack=callStack
  )
}

