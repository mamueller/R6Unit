#!/usr/bin/Rscript
if (!is.element('devtools',installed.packages())){
	install.packages('devtools',repos='https://cran.uni-muenster.de')
}
install.packages('stringr')
install.packages('getopt')
require(getopt)
require(stringr)
require(devtools)
devtools::install_github('mamueller/debugHelpers',subdir='pkg')
devtools::install('pkg',build=FALSE)
print(get_Rscript_filename())
