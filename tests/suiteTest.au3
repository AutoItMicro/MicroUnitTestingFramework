#Region include for test
#include <../micro.au3>
#EndRegion

#Region Test suite definition
Local $testSuite = _testSuite_("Test Suite Test")

$testSuite.addTest(assertTruePass())
$testSuite.addTest(assertFalsePass())
$testSuite.addTest(assertEqualsPass())

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

Func assertEqualsPass()
    $test = _test_("assertEquals returns True")
	$test.assertEquals("1, 1", 1, 1)
	$test.assertEquals('"a", "a"', "a", "a")
	$test.assertEquals("-13, -13", -13, -13)
	$test.assertEquals('"-13", "-13"', "-13", "-13")
	$test.assertEquals('True, True', True, True)
	$test.assertEquals('False, False', False, False)
    Return $test
EndFunc
#EndRegion
