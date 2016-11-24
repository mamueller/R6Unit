# R6Unit
This is small package in the way of Kent Becks original TestUnit using R6 classes in R
I needed the posibillity to inherit from TestCase for some special Tests (like building R  package documentation and cran checks installation)
that seemed cumbersome to build with RUnit or TestIt.
The package runs tests in parallel and has (or rather gradually develops) an interface similar to 
the python3 unittest
It is still undocumented but I will soon give roxygen2 a try.
