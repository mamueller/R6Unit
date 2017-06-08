
# vim:set ff=unix expandtab ts=2 sw=2:
summary.testError <- function(te){
  list(
    text=te$text,
    message=te$message,
    callStack=te$callStack
  )
}
