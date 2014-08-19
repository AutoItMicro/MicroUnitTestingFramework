#Region include for test
#include <../micro.au3>
#EndRegion

#Region Test suite definition
Local $testSuite = _testSuite_("Test Suite Test")

If $CmdLine[0] > 0 Then
    $testSuite.ci = True
EndIf

$testSuite.addTest(assertTruePass())
$testSuite.addTest(assertFalsePass())
$testSuite.addTest(assertEqualsPass())
$testSuite.addTest(assertNotEqualsPass())

$testSuite.finish()
#EndRegion

#Region Test Functions
Func assertTruePass()
    $test = _test_("assertTrue Passes")
	$test.assertTrue("True", True)
    Return $test
EndFunc

Func assertFalsePass()
    $test = _test_("assertFalse Passes")
	$test.assertFalse("False", False)
    Return $test
EndFunc

Func assertEqualsPass()
    $test = _test_("assertEquals Passes")
	$test.assertEquals("1, 1", 1, 1)
	$test.assertEquals('"a", "a"', "a", "a")
	$test.assertEquals("-13, -13", -13, -13)
	$test.assertEquals('"-13", "-13"', "-13", "-13")
	$test.assertEquals('True, True', True, True)
	$test.assertEquals('False, False', False, False)
    Return $test
EndFunc

Func assertNotEqualsPass()
    $test = _test_("assertNotEquals Passes")
	$test.assertNotEquals("1, 2", 1, 2)
	$test.assertNotEquals('"a", "b"', "a", "b")
	$test.assertNotEquals("-13, 13", -13, 13)
	$test.assertNotEquals('"13", "-13"', "13", "-13")
	$test.assertNotEquals('True, False', True, False)
	$test.assertNotEquals('False, True', False, True)
    Return $test
EndFunc
#EndRegion
