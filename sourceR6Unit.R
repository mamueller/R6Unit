#!/usr/bin/Rscript
# vim:set ff=unix expandtab ts=2 sw=2:
library(R6)
library(logging)
library(parallel)

p<-file.path("pkg","R")
srcFileNames<-list.files(path=p)
lapply(srcFileNames,function(fn){source(file.path(p,fn))})

