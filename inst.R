#!/usr/bin/Rscript
if (!is.element('devtools',installed.packages())){
	install.packages('devtools',repos='https://cran.uni-muenster.de')
}
require(devtools)
install.packages('stringr')
devtools::install('pkg',build=FALSE)
devtools::install_github('mamueller/debugHelpers',subdir='pkg')
require(getopt)
require(stringr)
print(get_Rscript_filename())
