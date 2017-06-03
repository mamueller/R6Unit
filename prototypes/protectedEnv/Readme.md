The purpose of this prototype is to 
explore the possibility to isolate 
the execution environments of tests
especially when the tests use functions with side effects like 
library or require.
A successful strategie seems to be to fork another process as the example

protectedEnvByFork.R 

suggests.


