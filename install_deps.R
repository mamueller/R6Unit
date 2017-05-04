#!/usr/bin/Rscript
# vim:set ff=unix expandtab ts=2 sw=2:
#args<-commandArgs(trailingOnly = TRUE)
args<-c("logging","stringi","stringr","argparse","RUnit")
for (pkgName in args) {
  install.packages(pkgName,repo="https://cran.uni-muenster.de")
}
