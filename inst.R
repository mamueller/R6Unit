#!/usr/bin/Rscript
if (!is.element('devtools',installed.packages())){
	install.packages('devtools',repos='https://cran.uni-muenster.de')
}
require(devtools)
devtools::install('pkg')
devtools::install_cran('stringr')
require(getopt)
print(get_Rscript_filename())
