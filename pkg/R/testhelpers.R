##
## vim:set ff=unix expandtab ts=2 sw=2:
######################################################################################################
#  .lineSplitter=function(line,sep,pos){if (nchar(line)>pos){line=sub(sep,paste(sep,"\n",sep=""),line)};line}
#  .textSplitter=function(utxt,sep,pos){
#    Lines=unlist(strsplit(utxt,"\n"))
#    utxt=paste0(unlist(lapply(Lines,.lineSplitter,sep,pos)),collapse="\n")
#    utxt
#  }
#  .widthCutter=function(utxt,pos){
#    newtxt=.textSplitter(utxt,",",pos)
#    newtxt=.textSplitter(newtxt,"\\(",pos)
#    newtxt=.textSplitter(newtxt,"\\)",pos)
#    if (newtxt==utxt){
#      return(utxt)
#    }else{
#      return(.widthCutter(newtxt,pos))
#    }
#  }
