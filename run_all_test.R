#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:

#pkgName<-"R6Unit"
#if(is.element(pkgName,installed.packages())){
#  remove.packages(pkgName)
#}
#install.packages(file.path("pkg"),repo=NULL,INSTALL_opts="--with-keep.source")
#require(devtools)
#devtools::install('pkg')
#library(R6Unit)
require(pkgload)
pkgload::load_all("pkg",export_all=FALSE)
s<-get_suitefromDiscoveredTestInstances(".","^Test.*.R")
tr<-s$run()
cat(tr$get_names())
cat(tr$summary())
#sr<-tr$get_singleResult("TestTestCase.test.Output")
#print(class(sr))
#cat(sr$summary())
#print(tr$get_stdOut())

if ((tr$get_nFailures()+tr$get_nErrors())>0) stop(1)
