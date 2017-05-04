# R6Unit
This is small package in the way of Kent Becks original TestUnit using R6 classes in R
I needed the posibillity to inherit from TestCase to build hirarchies of more and more specialized tests,
ranging from simple io tests that have a private temporary test directory to
test that build R package documentation or check example R packages by cran.
It seemed cumbersome to implement this with RUnit or TestIt.
The package runs tests in parallel and has (or rather gradually develops) an interface similar to 
the python3 unittest
It is still undocumented but I will soon give roxygen2 a try.

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
