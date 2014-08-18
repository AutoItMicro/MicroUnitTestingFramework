#Region include for test
#include <../micro.au3>
#EndRegion

#Region Test
$test = _test_("assertTrue(true) returns pass")
$test.assertTrue("True", True)
#EndRegion
