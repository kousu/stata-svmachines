Compiling Stata-SVM
===================

This is the developer documentation for Stata-SVM.
It covers how to install dependencies, build the code, test and release it.
If you just want to use it, see [INSTALL](INSTALL.md).

Build requirements:
* GNU make
* a compiler

Toolchain
---------

To build, you will need to have your platform's compilation toolchain installed, as well as GNU make (gmake), as the Makefile is written against gmake.

You can test if you have the compiler installed with (*nix, including OS X and MinGW):
```
$ gcc -v
```

or (Windows with VS)
```
C:> cl.exe
```

And you can test if you have make installed by running it in an empty directory:
```
$ make
make: *** No targets specified and no makefile found.  Stop.
```

If either of these fail, you will need to install your compilers before continuing.

### Windows

On Windows, you should install [msys2](https://www.msys2.org/) and inside its shell install

```
pacman -S make
```

You can compile with the free GCC if you install

```
pacman -S mingw-w64-ucrt-x86_64-gcc
```

or you can use Microsoft's Visual Studio. To use Visual Studio, once you have it installed, amend your %PATH% by [using `vcvarsall.bat`](https://msdn.microsoft.com/en-us/library/f2ccy3wt.aspx) every time you start a command prompt session; here are some command lines which will accomplish this but **beware that you will need to adjust these paths if you have a different version of VS**. For 32 bit builds:
```
C:> "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
```
and for 64-bit:
```
C:> "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
```
There are also "Developer Command Prompt" shortcuts in your start menu, as described in the above link. Remember that whichever method you use, you must do it every time you begin a session!

The build _should_ work under either compiler; please report problems, especially if the build works with one compiler but not the other.

### OS X

On OS X, you will need the **Command Line Tools** package:

```
$ xcode-select --install
```

### *nix

On modern Linux or other *nix, gcc and make will usually be installed by default.
If they are not, search your distro's documentation.


libsvm
------

[libsvm](http://www.csie.ntu.edu.tw/~cjlin/libsvm/) is the C library which does the heavy lifting. Stata-SVM is a thin wrapper which exposes its routines and makes them Stata-esque.

We _vendor_ a libsvm (see [src/libsvm.mk](src/libsvm.mk)), meaning we compile it from source and then embed it directly inside the the plugins.


Building
--------

Once you have set up a compiler, open a shell **in the `src/` subdirectory** and run

```
$ make
```

(If the build fails for you **please file bug reports**. We are a small team and cannot cover all platforms at all times, but we will address your problem and help you to help us improve the package.)

As you make changes, you can just do `make` again to update the code.
However, as usual, you can get rid of the build cruft if you need to start from a known state with
```
$ make clean
```
(you have to do this, for example, when you change the Makefile, as make doesn't track its own Makefile)

Development Installation
------------------------

The proper way to install Stata-SVM is to use the [install instructions](INSTALL.md).
However, for development you want to be able to use the code in the repository.
The most replicable way to do this is to write a test case for every feature, bug, or change, and use `make tests` (see below).
But if that feels too slow for you follow these instructions

The idea is to make sure the folder with the runnable .ado files is on the adopath.
Since Stata, like Windows, by default considers the current directory to be on the adopath
the shortest method is to side-step installation entirely: just make sure you ". cd" Stata to `statasvm/src/`;
 with the Unix console Stata this is easy: launching Stata from the command line in `statasvm/src/` sets its working directory there.

But with the Windows and OS X graphical interface this is not so simple: they tend to start in a different directory.
The more involved but time-saving method is similar to python's `python setup.py develop`:
add the build directory to Stata's adopath,
using [`profile.do`](http://www.stata.com/manuals13/gswb.pdf#B.3ExecutingcommandseverytimeStataisstarted).
**If you have already customized your profile.do, you should edit the one you already have as Stata only runs one**.
If not, you can make `profile.do` in your home folder; this is typically
`/home/<username>/ado' on Unix,
'/Users/<username>/ado' on OS X, and
'C:\Users\<username>\Documents' on Windows.
Once you have found your `profile.do`, add this one line:
```
adopath + "path/to/statasvm/src"
```

Restart Stata and try to run `. svm`. You should see
```
. svm
varlist required
r(100);
```

If you see
```
. program _svm, plugin
Could not load plugin: .\_svm.plugin
```
then you have the path set right but the plugin is unloadable for some other reason ---
the file or one of its dependencies is corrupt, or you are trying to run the
wrong architecture (Windows code on OS X, 32 bit Windows on 64 bit Windows, etc).

If instead you see
```
. svm
command svm is unrecognized
r(199);
```
then you have the path set wrong. Check it with `adopath`.


Testing
-------

Quick tips:
* `. program drop _all` forgets cached .ado and dlclose()s all loaded DLLs, without needing to restart Stata
* `.

There is a haphazard suite of test cases in `src/tests/`. Working in `src/`, for each file `tests/x.do` the test can be run with
```
src/$ make tests/x
```

To see more details you can use either Stata's tracing or the internal debug flag or together:
```
src/$ TRACE=1 DEBUG=1 make tests/x
```

Once you have a package, described below, you should make sure it installs properly.
First, put up an HTTP server in the `dist/` folder:
```
src/dist/$ python3 -m http.server  #there are lots of other options too if you do not have python3
```
Then point Stata at it:
```
. net from http://localhost:8000
. net install svm
. 
. // For a single package, it is equivalent and faster to write:
. net install svm, from(http://localhost:8000)
```


A tip: as you fix bugs in this stage, you can force reinstallation of only your changes. After you `make pkg` do
```
. net install svm, from(http://localhost:8000) replace
```
The "replace" option will report only those files it discovered needed updating, which should match your changes.



Packaging
---------

Packaging is:

1. running `make dist` on each _supported platform_
2. merging the outputs onto a single machine (using rsync, sftp, thumbdrives, etc)
3. `make package`

The end result is `svmachines.zip` in the root of the repo. Shared and unzipped,
a user can `net from file://path/to/svmachines/` then `net describe svmachines`.

The build is run on Github Actions, so releases should mostly be automatic.
To produce a release, `git tag` and push -- it will show up in the releases
tab if all went well.

See [build.yml](.github/workflows/build.yml).
