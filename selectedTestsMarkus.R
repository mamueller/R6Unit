#!/usr/bin/Rscript 
# vim:set ff=unix expandtab ts=2 sw=2:

#source("R6_prolog.R")
#require(R6Unit)
require(pkgload)
pkgload::load_all("pkg",export_all=FALSE)
source("TestInDirScriptTest.R")
#source("TestTestCase.R")
#t2 <- TestInDirTest$new('test.writeInDir')
t2 <- TestInDirScriptTest$new('test.writeInDir')
#s<-TestSuite$new(list(t1,t2))
s<-TestSuite$new(list(t2))
#s<-TestSuite$new(list(tc))
print(s$test_names())
#s$add_test(tc)
tr <- s$run()
#stop(mmsg())

cat(tr$summary())
