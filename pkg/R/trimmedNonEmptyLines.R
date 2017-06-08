#
# vim:set ff=unix expandtab ts=2 sw=2:

trimmedNonEmptyLines=function(s){
  ### a helper function to make text comparison of actual and expacted output less painfull by removing whitespace
  t=str_trim(unlist(str_split(s,"\n")))
  ttr=t[nchar(t)>0]
  return(ttr)
}
