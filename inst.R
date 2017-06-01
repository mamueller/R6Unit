#!/usr/bin/Rscript
require(devtools)
devtools::install('pkg')
#devtools::install_cran('getopt')
require(getopt)
print(get_Rscript_filename())
