#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:

pkgName<-"R6Unit"
if(is.element(pkgName,installed.packages())){
  remove.packages(pkgName)
}
install.packages(file.path("pkg"),repo=NULL,INSTALL_opts="--with-keep.source")
library(R6Unit)
s<-get_suitefromDiscoveredTestInstances(".","^Test.*.R")
tr<-s$run()
tr$summary()
