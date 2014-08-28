Micro - The AutoIt Unit Testing Framework
=========================================

[![Build status](https://ci.appveyor.com/api/projects/status/bdbmu8v4dwmym6eb)](https://ci.appveyor.com/project/KyleChamberlin/microunittestingframework)

Micro is a xUnit style testing framework design for use with AutoIt. The goal of Micro is to be
easy to use and simple to integrate with continuous integration services.

We all write scripts and programs to make our lives easier; and they do make our lives easier, 
right up until it becomes something others rely on or it becomes something your business needs. 
This is where unit testing can really save you. Micro provides a simple assert based system for 
testing the fixtures of your code. The best part is that you will know when a change breaks 
another part of your script or program unexpectedly, and not after you ship it to a client who 
can't use it. 

Using Micro
-----------

To use micro you simply need to add it as a submodule to the project you'd like to test.

    cd <project you would like to test's root>
    git submodule add git://github.com/AutoItMicro/MicroUnitTestingFramework.git micro
    git submodule update --init --recursive

now if you add micro/micro.au3 as an include in your test script you are good to go.

### Writing Tests

To begin using Micro to test you just need to write your first test. We suggest writing a function for each test like this:

MyTests.au3:
```AutoIt
#include <micro/micro.au3>
#include <myScriptToTest.au3>

Func myFunctionTest()
	$test = newTest("myFunction performs like this")
	$test.assertEquals('myFunction($someInput) returns "This"', myFunction($someInput), "This")
	Return $test
EndFunc
```

Now we need a testSuite for this test, so let's make one and add this test to it.

MyTests.au3:
```AutoIt
$testSuite = newTestSuite("My awesome test suite")
$testSuite.addTest(myFunctionTest())
$testSuite.finish()
```

### Notes

Micro is currently being re-written and is not accepting blanked pull requests. if you would like 
to contribute, please contact @KyleChamberlin for more information on how to help contribute 
during this re-write.

##### Attribution

This code was originally forked from http://sourceforge.net/projects/microtest/
