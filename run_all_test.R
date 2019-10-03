#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:

require(pkgload)
pkgload::load_all("pkg",export_all=FALSE)
s<-get_suitefromDiscoveredTestInstances(".","^Test.*.R")
tr<-s$run()
tr$print_summary()

if ((tr$get_nFailures()+tr$get_nErrors())>0) stop(1)
