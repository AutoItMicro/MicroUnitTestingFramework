#Region include for test
#include <../micro.au3>
#EndRegion

#Region Test suite definition
Local $testSuite = _testSuite_("Test Suite Test")

$testSuite.addTest(assertTruePass())
$testSuite.addTest(assertTrueFail())

$testSuite.finish()
#EndRegion

#Region Test Functions
Func assertTruePass()
    $test = _test_("assertTrue(true) returns Passed")
	$test.assertTrue("True", True)
    Return $test
EndFunc

Func assertFalsePass()
    $test = _test_("assertFalse(False) returns True")
	$test.assertFalse("False", False)
    Return $test
EndFunc
#EndRegion
