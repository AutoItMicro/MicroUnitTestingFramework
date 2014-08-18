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
    $test = _test_("assertTrue(true) returns pass")
	$test.assertTrue("True", True)
    Return $test
EndFunc

Func assertTrueFail()
    $test = _test_("assertTrue(true) returns pass")
	$test.assertTrue("False", False)
    Return $test
EndFunc
#EndRegion
