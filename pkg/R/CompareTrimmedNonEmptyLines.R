#
# vim:set ff=unix expandtab ts=2 sw=2:
CompareTrimmedNonEmptyLines=function
  ### helper function needed for comparison of doc files
  (s1,s2)
  {
  t1=trimmedNonEmptyLines(s1)
  t2=trimmedNonEmptyLines(s2)
  l1=length(t1)
  l2=length(t2)
  if (l1!=l2){
    print(paste("The number of lines differs l1=",l1,"  l2=",l2 ))
    return(FALSE)
  }
  for(i in (1:l1)){
    ti1=t1[[i]]
    ti2=t2[[i]]
    if (ti1!=ti2) {
      print("\n")
      print(ti1)
      print(ti2)
      print(paste("line",i,"does not match"))
      return(FALSE)
    }
  }
  return(TRUE)
}

