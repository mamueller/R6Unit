#
# vim:set ff=unix expandtab ts=2 sw=2:
# in R conditions (as e.g. errors or warnings are S3 classes
# here we provide a constructor 
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    class = c(subclass, "condition"),
    list(message = message, call = call, ...)
  )
}
