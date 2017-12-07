C++Make
======
This is the C++ verision of the CMake Makefile. This [Makefile](./Makefile "Makefile") will make an executable of `name` using all `.cpp`, `.h`, and `.o` files required to build it. It will be built according the gnu++ 11 C++ standards.


Running the command `make clean` will remove all extraneous files and directories except the source code.

Running the command `make valgrind` will run the program and check it for memory leaks with the valgrind program. A log file called `valgrind.out` will be made with the memory leak test results.